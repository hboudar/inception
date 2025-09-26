-theory concepts
-scripts logic of each container


-Pid 1
-Daemons
-Diff between containers and vms


/Docker/          : A tool designed to build, deloy and run applications using containers.
/Container/       : A running instance of a Docker image, It’s isolated, but shares the host OS kernel.
/Docker image/    : A read-only blueprint of an application,
                      containing the application code, libraries, dependencies,
                      and environment settings needed to run.

/Volume/          : Presistent storage of containers.
                      They allow data to exist independently of a container´s lifecycle.

/Network/         : Docker-managed virtual networking.
                      lets containers communicate with each other or the outside world securely.

/Docker-File/     : A text file with instructions for building a Docker Image.
/Docker-Compose/  : A tool for defining and running multi-container application
                      using a single YAMAL file (Services, networks, volumes)