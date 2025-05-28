# SET-UP

* FROM debian:bullseye : for all images(must).
• Each Docker image = its corresponding service.
• All CONTAINERS have to restart in case of a crash..
* It is forbidden to use : host or --link or links.
* The CONTAINERS must not be started with an infinite loop command
  (also applies to commands used as entrypoint)
  (or used in entrypoint scripts)
  (tail -f, bash, sleep infinitty, while true)
• in WordPress database : must be two users :
  1- the administrator username cant´t containe : admin/Admin - admin-istrator/Administrator
      (e.g., admin, administrator, Administrator, admin-123, and so forth)
• volumes : will be available in the /home/login/data folder


/NGINX/ web server and reverse proxy
  443 / TLSv1.2 or TLSv1.3
  terminates SSL(HTTPS), serves static assets(CSS, JS), forwards PHP requests to WordPress+PHP(9000)
  linked with WordPress+PHP(9000)
  Network[my-net]

/WordPress/ Processes PHP scripts, dynamically generates HTML
  DB(3306) NGINX(9000 'FastCGI if using php-fpm')
  linked with DB(to fetch/save content) NGINX(to serve processed pages)
  Volume[WordPress website files]
  Volume[WordPress database]
  Network[my-net]


/MARIADB/ Database backend(Stores presistent data[posts, user info, settings])
• A Docker container that contains MariaDB only without nginx.
  3306
  linked with WordPress+PHP
  Volume(Mounted for data presistence)
  Network[my-net]



# MUST KNOW / HANDLE + INFO #
  • Read about how daemons work and whether it is a good idea to use them or not
  • The network line must be presented in .yml file.
  • Read about PID 1

  /• For obvious security reasons, any credentials, API keys, passwords, etc... must be saved locally in various ways
  files and ignored by git. Publicly stored credentials will lead you directly to a failure of the project./

  /•Certificates serve two fundamental purposes:
  - Authentication: They prove the server's identity to the client
  - Encryption: They enable the establishment of a secure, encrypted session (TLS handshake)/
