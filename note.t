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



  /• For obvious security reasons, any credentials, API keys, passwords, etc... must be saved locally in various ways
  files and ignored by git. Publicly stored credentials will lead you directly to a failure of the project./ #done

  /•Certificates serve two fundamental purposes:
  - Authentication: They prove the server's identity to the client
  - Encryption: They enable the establishment of a secure, encrypted session (TLS handshake)/
_______________________________________________________________________________________________________