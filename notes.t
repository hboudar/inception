#SET-UP
/NGINX/ web server and reverse proxy
  443
  terminates SSL(HTTPS), serves static assets(CSS, JS), forwards PHP requests to WordPress+PHP(9000)
  linked with WordPress+PHP(9000)

/WordPress/ Processes PHP scripts, dynamically generates HTML

  DB(3306) NGINX(9000 'FastCGI if using php-fpm')
  linked with DB(to fetch/save content) NGINX(to serve processed pages)
  Volume(sotores WordPress files and configs[themes, uploads])

/MARIADB/ Database backend(Stores presistent data[posts, user info, settings])
• A Docker container that contains MariaDB only without nginx.
  3306
  linked with WordPress+PHP
  Volume(Mounted for data presistence[ex : /var/lib/mysql])



# FOR ALL CONTAINERS #
• Each Docker image = its corresponding service
• A Docker Network
• Your containers have to restart in case of a crash.
• A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.
• A Docker container that contains WordPress + php-fpm (it must be installed and configured) only without nginx.
• A volume that contains your WordPress database.
• A second volume that contains your WordPress website files.


# MUST KNOW / HANDLE + INFO #
  • Read about how daemons work and whether it is a good idea to use them or not
  • The network line must be presented in .yml file.

  /• For obvious security reasons, any credentials, API keys, passwords, etc... must be saved locally in various ways
  files and ignored by git. Publicly stored credentials will lead you directly to a failure of the project./

  /•Certificates serve two fundamental purposes:
  - Authentication: They prove the server's identity to the client
  - Encryption: They enable the establishment of a secure, encrypted session (TLS handshake)/

  • FROM alpine:3.18 / FROM debian:bullseye
