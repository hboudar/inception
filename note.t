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

https://localhost:8443


why not using .env or args for passwords and using secrets?
-------------------------------------------------
WordPress script :
#!/bin/bash: Shebang — tells the system to execute this file using Bash.

set -euo pipefail: Shell options:

-e: Exit immediately if a command fails.
-u: Treat unset variables as errors.
-o pipefail: Makes the whole pipeline fail if any command in it fails (important for security).

trap: If anything fails, print the line number — helps debugging.

mysqladmin ping -h "$DB_HOST": Sends a ping to the MariaDB host.
--silent: Suppresses unnecessary output.
until ...; do sleep 2; done: Loop until MariaDB is responsive.
This prevents the script from continuing before the DB is actually ready — critical in multi-container setups.

command -v wp: Checks if wp (WordPress CLI) exists.
If not:
curl -sSLO: Download silently with error reporting.
chmod +x: Make it executable.
mv: Move it to a system path so it´s globally accessible.
WP-CLI is essential for automating WordPress setup in headless containers.

wp core download --allow-root
Downloads WordPress core files.
--allow-root: Required because container usually runs as root.

wp config create.....
Creates wp-config.php with DB credentials.
--skip-check: Skips DB connection check (assumes MariaDB is ready).
Critical point for DB auth and connectivity.

wp core install .....
Sets up WordPress with admin credentials and site info.
This runs wp-admin/install.php in headless mode.

wp user create.....
Adds a second user with author permissions.
Useful for testing or restricted access.

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
chown: Sets ownership to the web server user.
chmod 755: Safe default that gives full access to owner and read-execute to others.