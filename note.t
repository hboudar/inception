# SET-UP

* FROM debian:bullseye : for all images(must). #done

• Each Docker image = its corresponding service. #done

• All CONTAINERS have to restart in case of a crash.. #done

* It is forbidden to use : host or --link or links. #done

* The CONTAINERS must not be started with an infinite loop command #done
  (also applies to commands used as entrypoint)
  (or used in entrypoint scripts)
  (tail -f, bash, sleep infinitty, while true)

• in WordPress database : must be two users : #done
  1- the administrator username cant´t containe : admin/Admin - admin-istrator/Administrator
      (e.g., admin, administrator, Administrator, admin-123, and so forth)

• volumes : will be available in the /home/login/data folder #done


/NGINX/ web server and reverse proxy
  443 / TLSv1.2 or TLSv1.3 #done
  terminates SSL(HTTPS), serves static assets(CSS, JS), forwards PHP requests to WordPress+PHP(9000) #done
  linked with WordPress+PHP(9000) #done
  Network[my-net] #done

/WordPress/ Processes PHP scripts, dynamically generates HTML
  DB(3306) NGINX(9000 'FastCGI if using php-fpm') #done
  linked with DB(to fetch/save content) NGINX(to serve processed pages) #done
  Volume[WordPress website files] #done
  Volume[WordPress database] #done
  Network[my-net] #done


/MARIADB/ Database backend(Stores presistent data[posts, user info, settings])
• A Docker container that contains MariaDB only without nginx. #done
  3306 #done
  linked with WordPress+PHP #done
  Volume(Mounted for data presistence) #done
  Network[my-net] #done



# MUST KNOW / HANDLE + INFO #
  • Read about how daemons work and whether it is a good idea to use them or not
  • The network line must be presented in .yml file.
  • Read about PID 1

  /• For obvious security reasons, any credentials, API keys, passwords, etc... must be saved locally in various ways
  files and ignored by git. Publicly stored credentials will lead you directly to a failure of the project./ #done

  /•Certificates serve two fundamental purposes:
  - Authentication: They prove the server's identity to the client
  - Encryption: They enable the establishment of a secure, encrypted session (TLS handshake)/

https://localhost:443
https://localhost:443/wp-admin/edit.php
http://localhost:8080
ftp -p 127.0.0.1 2121



why not using .env or args for passwords and using secrets?
the diff between : unless-stopped / always in .yml


-----------------
NOTE: Read about PID 1 and the best practices for writing Dockerfiles.

NOTE: A Docker container is not a virtual machine. Thus, it is not
recommended to use any hacky patches based on ’tail -f’ and similar
methods when trying to run it. Read about how daemons work and
whether it’s a good idea to use them or not.


REQUIREMENT: To simplify the process, you must configure your domain name to point to your local
IP address.
This domain name must be login.42.fr. Again, you must use your own login.
For example, if your login is ’wil’, wil.42.fr will redirect to the IP address pointing to
Wil’s website.




i ve been running around f rassi ghi sm7oli ila nssit



________________________________________________________________________________________________________
# DOCKER : 
A tool designed to build, deploy and run applications using containers,
in an isolated environment, across different operating systems and platforms.

# CONTAINERS :
lightweight virtualized unit that package up code, dependencies, libraries and configurations
needed to run an application, ensuring consistency across different environments.

# DIFF BETWEEN CONTAINERS AND VIRTUAL MACHINES :
containers virtualize the operating system, while VM virtualize the hardware.

# IMAGES :
read-only templates used to create containers, containing the application code, libraries, dependencies,

# DOCKERFILE :
a text file that contains a set of instructions to build a Docker image,

# DOCKER COMPOSE :
A tool designed to define and run multi-container Docker applications
three important parts:
1. Services: Define the different containers that make up the application.
2. Networks: Define how the containers communicate with each other.
3. Volumes: Define persistent data for the containers.

# PID 1 :
Is the idnetifier of the init process, which is the first process started when the system boots up.
-It is responsible for starting and stoping the application running in the container.
(pid 1 in a docker container behave differently from the init process in a normal Unix-based system. (they are not the same))




final notes : 

#0 Theory : more about concepts like : docker,docker compos, pid1...

#1 Makefile :
  remove the SHELL := /bin/bash (?)
  remove alpine method (?)
# theory : scripts, used for?, network, volumes

#wordpress
how to edit a page and verify on the website that the page has been updated.

#mariadb
how to login into the database.
how to verify the database is not empty.
