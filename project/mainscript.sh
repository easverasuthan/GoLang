#!/bin/bash
# Ansible Installation

if ! yum list installed | grep ansible
then
        echo "Not Installed"
        yum -y install epel-release && yum -y install ansible
        version=$(ansible --version)
        echo "The installed ansible version is $version"
else
        echo "Installed"
fi

# Docker Installation

if ! yum list installed | grep docker
then
        echo "Not Installed"
        sudo yum install -y yum-utils device-mapper-persistent-data lvm2
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum -y install docker-ce docker-ce-cli containerd.io
        service docker start
        version1=$(docker --version)
        echo "The installed docker version is $version1"
else
        echo "Installed"
fi

# Staring  remote docker

if [ ! -f /tmp/docker.service ]
then
        echo "Doesn't Exist"
        cp /lib/systemd/system/docker.service /tmp/
else
        echo "Exists"
fi
sed -i '/ExecStart/c\ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:4243 --containerd=/run/containerd/containerd.sock' /lib/systemd/system/docker.service
systemctl daemon-reload
sudo service docker restart
curl http://localhost:4243/version

# Launching Containers
docker pull centos > /dev/null
i=0;
while read p; do
  hostname=$( echo $p | cut -d '|' -f1 )
  echo $hostname
  portno=$( echo $p | cut -d '|' -f2 )
  echo $portno
docker run -p $portno:8484 --name=$hostname --hostname=$hostname -dt centos
  sudo cp /opt/project/sample /opt/project/host
  sudo sed -i 's/containername/'"$hostname"'/g' /opt/project/host
  cp /etc/ansible/hosts /opt/project/$hostname
  cat /opt/project/host | tee -a /opt/project/$hostname >/dev/null
  ansible-playbook -i $hostname mainplaybook.yml
  dockerip=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" $hostname)
  echo $dockerip
  i=$((i+1))
  sed -i "s/container$i/"$dockerip"/g" /opt/project/loadbalancerconf
done <chname
#Installing and Configuring Nginx
if ! yum list installed | grep nginx 
then
	yum -y install nginx
        sudo sed -i '/http {/ r loadbalancerconf' /etc/nginx/nginx.conf
        sudo sed -i '0,/location \/ {/ s/location \/ {/location \/ { \n proxy_pass http:\/\/backend;/' /etc/nginx/nginx.conf
  	cp mainloadconf loadbalancerconf
  	service nginx start
else
	echo "already installed"
fi
