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

/For obvious security reasons, any credentials, API keys, passwords, etc... must be saved locally in various ways /
/files and ignored by git. Publicly stored credentials will lead you directly to a failure of the project./


# Based images #
FROM alpine:3.18
FROM debian:bullseye


#info
/Certificates serve two fundamental purposes:
  - Authentication: They prove the server's identity to the client
  - Encryption: They enable the establishment of a secure, encrypted session (TLS handshake)
/

/Due to rootless Docker restrictions on ports < 1024, 443 is mapped to a higher port (8443) externally,
  but inside the container NGINX listens strictly on 443 — satisfying the subject requirement.

  If asked why you're mapping to 8443 instead of 443, answer directly:

Because Docker is running in rootless mode, and ports below 1024 (like 443) are privileged.
Rootless containers can't bind to privileged ports unless extra configuration is done on the host (e.g. modifying sysctl or giving binary capabilities), which is not allowed in the Inception project.

So, the container listens internally on 443, but externally we map it to a non-privileged port like 8443 — this keeps the setup compliant with the subject’s instruction:
"Only allow HTTPS over port 443 between the NGINX container and the web."

This explanation shows:

You understand the system limitation

You respect project constraints

You made a reasonable and compliant workaround

Let me know if you want a one-liner version for your .md or README.

Here’s a concise one-liner explanation for your README or report:

Due to rootless Docker restrictions disallowing binding to privileged ports (<1024), we map container’s internal port 443 to external port 8443 to comply with project rules without requiring host privilege changes.
/