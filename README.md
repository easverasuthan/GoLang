#Table of Contents 

**##Summary**

This project installs `ansible`, `docker` in our cloud machine, launches two `docker` containers and deploys sample Golang application in 
those containers. Then via `Nginx`, it loadbalances the requests between the containers using round `robin fashion`.

**##Prerequisites**

Launch a centos machine in any public cloud provider(preferred - `AWS`) and execute 
  	>sudo su
    	>Git clone https://github.com/easverasuthan/GoLang.git 

**##Steps for running the script**

1. You will be having one directory named `project` in the directory where you have cloned the project.

2. Copy the directory project to `/opt/` and execute the below commands.
	
 	>cp -r project /opt/
 	>cd  /opt/
 	>sh mainscript.sh

3. Once the script execution is completed, do open port `80` in the inbound of the machine.

4. Then hit http://ip in the browser. You will see a request from one of the container.

5. If you refresh the page, `Nginx` will load balance the request between the two containers in a `round robin` fashion.
