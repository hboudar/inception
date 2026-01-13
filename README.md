<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Inception — 42 Project</title>
</head>
<body>

  <p><em>This project has been created as part of the 42 curriculum by &lt;your_login&gt;.</em></p>

  <h1>Inception</h1>

  <h2>Description</h2>
  <p>
    <strong>Inception</strong> is a system administration and DevOps-oriented project that focuses on
    designing and deploying a secure, containerized web infrastructure using
    <strong>Docker</strong> and <strong>Docker Compose</strong>.
  </p>

  <p>
    The goal of the project is to virtualize a complete web stack inside a Linux virtual machine,
    where each service runs in its own isolated container and communicates through a dedicated
    Docker network.
  </p>

  <p>
    The infrastructure serves web content over HTTPS, including a WordPress website (HTML/PHP),
    and follows strict rules regarding security, persistence, and container best practices.
  </p>

  <h2>Architecture Overview</h2>
  <ul>
    <li><strong>NGINX</strong> — Acts as the single entry point, serving content over HTTPS (TLSv1.2 / TLSv1.3)</li>
    <li><strong>WordPress + PHP-FPM</strong> — Handles dynamic web content without embedding NGINX</li>
    <li><strong>MariaDB</strong> — Stores WordPress data in a dedicated database container</li>
    <li><strong>Docker Network</strong> — Enables secure inter-container communication</li>
    <li><strong>Docker Volumes</strong> — Persist database data and website files</li>
  </ul>

  <h2>Key Requirements Implemented</h2>
  <ul>
    <li>All services run in separate containers</li>
    <li>Custom Dockerfiles written for each service (no prebuilt images)</li>
    <li>Built from Alpine or Debian base images</li>
    <li>Persistent data using Docker volumes</li>
    <li>Environment-based configuration using <code>.env</code></li>
    <li>No hardcoded credentials inside Dockerfiles</li>
    <li>Automatic container restart on failure</li>
    <li>NGINX exposed on port 443 only</li>
  </ul>

  <h2>Project Structure</h2>
  <p>
    The project follows a clear and modular directory layout:
  </p>
  <ul>
    <li><code>Makefile</code> — Builds and runs the entire infrastructure</li>
    <li><code>srcs/</code> — Contains Docker Compose, environment variables, and service definitions</li>
    <li><code>srcs/requirements/</code> — One folder per service (NGINX, WordPress, MariaDB)</li>
    <li><code>secrets/</code> — Stores sensitive credentials (ignored by git)</li>
  </ul>

  <h2>Instructions</h2>
  <p>
    To build and start the infrastructure:
  </p>
  <pre>
make
  </pre>

  <p>
    To stop and clean containers, networks, and volumes:
  </p>
  <pre>
make down
  </pre>

  <p>
    Once running, the website is accessible via:
  </p>
  <pre>
https://&lt;login&gt;.42.fr
  </pre>

  <h2>Design Choices</h2>
  <h3>Virtual Machines vs Docker</h3>
  <p>
    Docker provides lightweight isolation at the process level, faster startup times,
    and easier service orchestration compared to full virtual machines.
  </p>

  <h3>Secrets vs Environment Variables</h3>
  <p>
    Environment variables are used for non-sensitive configuration, while secrets are
    stored separately to avoid exposing credentials in the repository.
  </p>

  <h3>Docker Network vs Host Network</h3>
  <p>
    A dedicated Docker network ensures controlled communication between containers and
    avoids exposing internal services directly to the host.
  </p>

  <h3>Docker Volumes vs Bind Mounts</h3>
  <p>
    Docker volumes are used for better portability, isolation, and data persistence
    independent of the container lifecycle.
  </p>

  <h2>Resources</h2>
  <ul>
    <li>Docker Documentation</li>
    <li>Docker Compose Documentation</li>
    <li>NGINX Official Docs</li>
    <li>WordPress & PHP-FPM Documentation</li>
    <li>MariaDB Documentation</li>
  </ul>

  <p>
    AI tools were used selectively for documentation refinement and command reference,
    with all configurations fully reviewed and understood.
  </p>

</body>
</html>
