# Theory concepts

-Daemons
-Diff between containers and vms


/Docker/        : A tool designed to build, deploy and run applications using containers.
                  $Docker_Daemon(dockerd) : Background service that creates, runs, and manages containers.
                  $Dcoker_CLI(docker) : command-line interface you use to talk to the Daemon.
                  $Docker_API : HTTP API that the CLI or other tools use to control Docker.

        {Docker} is not a VM, it shares the host OS kernel but isolates environments using Linux kernel features:
          Namespaces: give each container its own "view" of the system(cpu, network, files)
          Cgroups(control group): control how much cpu, memory, and disk each container can use. 
          Union filesystems:  stack multiple read-only image layers with a writable container layer on top.


/Docker image/  : {1} A read-only blueprint of an application,
                    containing the application code, libraries, dependencies,
                    and environment settings needed to run.
                  {2} built layer by layer :
                    Base layer -> (alpine, ubuntu)
                    Itermediate layer -> commands (RUN, COPY...)
                    Top writable layer -> (This is where container-specific changes (logs, temporary files) live.)
                  {3} Docker uses a union filesystem (like OverlayFS) to merge layers.
                  {4} Caching layers


/Container/     : A running instance of a Docker image, It’s isolated, but shares the host OS kernel.

/Volume/        : Presistent storage of containers.
                    They allow data to exist independently of a container´s lifecycle.

/Network/       : Docker-managed virtual networking.
                    lets containers communicate with each other or the outside world securely.

/Docker-File/   : A text file with instructions for building a Docker Image.

/PID 1/         : is the first process in a Namespace.
                    {1} PID 1 has extra responsibilities (like reaping zombie processes).
                    {2} If PID 1 dies, the whole container stops.

/Daemons/       : A Background service process
                    {start at boot, Run detached from terminal, provide services(networking, scheduling...)}


/Docker-Compose/  : A tool for defining and running multi-container application
                      using a single YAMAL file (Services, networks, volumes)


                    /Container                      VS                   Vm/
isolation   : os-level(Namespaces, Cgroups)                     hardware-level(hypervisor)
kernel      : shares host kernel                                has its own guest kernel
startup time: milliseconds                                      minutes
size        : MBs                                               GBs
performance : Near-native                                       More overhead
best for    : Microservices, portable applications              Full OS isoltaion, running different kernels

key takeaway :
{Containers} = lightweight, fast, app-focused.
{VMs} = heavyweight, fully isolated, OS-focused.


# Scripts logic of each container