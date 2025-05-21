# NGINX #
• A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only. (should work on https only )

# WORKDPRESS #
• A Docker container that contains WordPress + php-fpm (it must be installed and configured) only without nginx.
• A volume that contains your WordPress database.
• A second volume that contains your WordPress website files.

# MARIADB #
• A Docker container that contains MariaDB only without nginx.

# FOR ALL CONTAINERS #
• Each Docker image must have the same name as its corresponding service.
• A docker-network that establishes the connection between your containers.
• Your containers have to restart in case of a crash. \
    they must not be started with a command running an infinite loop (also applies to any command used as entrypoint or entrypoint scripts) \
    no : tail -f, bash, sleep infinitly, while true.



# MUST KNOW #
Read about how daemons work and whether it is a good idea to use them or network
The network line must be presented in .yml file.


# Based images #
FROM alpine:3.18
FROM debian:bullseye


#info
/Certificates serve two fundamental purposes:
  - Authentication: They prove the server's identity to the client
  - Encryption: They enable the establishment of a secure, encrypted session (TLS handshake)
/