Source: https://docs.docker.com/get-started/

# Important
## Windows
- On Windows systems, CTRL+C does not stop the container. So, first type CTRL+C to get the prompt back (or open another shell), then type docker container ls to list the running containers, followed by docker container stop <Container NAME or ID> to stop the container. Otherwise, you get an error response from the daemon when you try to re-run the container in the next step.
- On Windows, some commands will not work properly/generate useless output unless you run in **ADMINISTRATOR** mode. `docker-machine` commands must be ran with full admin access.

# Installation
[Docker CE](https://docs.docker.com/install/)
https://docs.docker.com/docker-for-windows/

# containerization
Docker is a platform for developers and sysadmins to develop, deploy, and run applications with containers.

# Docker App Hierarchy
- Stacks
    - Services
        - Containers

# Containers
A runtime instance of an image--what the image becomes in memory when executed (that is, an image with state, or a user process). You can see a list of your running containers with the command, docker ps, just as you would in Linux.
- Access to resources like networking interfaces and disk drives is virtualized inside this environment, which is isolated from the rest of your system, so you need to map ports to the outside world, and be specific about what files you want to “copy in” to that environment. 
## container vs VM
- containers virtualize only application layer, but retain host's kernal processes
## benefits
- run anywhere and scalable
- runs natively on Linux
- shares the kernel of the host machine with other containers

# Images
An image is an executable package that includes everything needed to run an application--the code, a runtime, libraries, environment variables, and configuration files.
## Image Public Naming Convention and Tagging
> docker tag image username/repository:tag # docker tag friendlyhello gordon/get-started:part2
# Docker File
Defines a portable image. E.g. For a Python app, define the Python run time, dependencies, etc.

### Example for a Python App
```dockerfile
# Use an official Python runtime as a parent image
FROM python:2.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
```

# Services
In a distributed application, different pieces of the app are called “services”.
Services are deployed images but they control the deployment of that image - e.g. number of instances.
## Service Hierarchy
- swarm
- stack
- service
- container/task
```bash
$ docker service ps pyapps9821_web
ID                  NAME                IMAGE                             NODE                    DESIRED STATE       CURRENT STATE           ERROR               PORTS
l1497by8nak4        pyapps9821_web.1    willdocker9821/pyapp9821:v1.0.0   linuxkit-00155d012601   Running             Running 3 minutes ago
id5k92nv3qac        pyapps9821_web.2    willdocker9821/pyapp9821:v1.0.0   linuxkit-00155d012601   Running             Running 3 minutes ago
obs7vdcsl330        pyapps9821_web.3    willdocker9821/pyapp9821:v1.0.0   linuxkit-00155d012601   Running             Running 3 minutes ago
l6tegao95i33        pyapps9821_web.4    willdocker9821/pyapp9821:v1.0.0   linuxkit-00155d012601   Running             Running 3 minutes ago
x473cunbw0hv        pyapps9821_web.5    willdocker9821/pyapp9821:v1.0.0   linuxkit-00155d012601   Running             Running 3 minutes ago

$ docker container ls
CONTAINER ID        IMAGE                             COMMAND             CREATED             STATUS              PORTS               NAMES
6673bfda2b0c        willdocker9821/pyapp9821:v1.0.0   "python app.py"     3 minutes ago       Up 3 minutes        80/tcp              pyapps9821_web.5.x473cunbw0hv01lba9kkfbdzj
6b7df3b19b31        willdocker9821/pyapp9821:v1.0.0   "python app.py"     3 minutes ago       Up 3 minutes        80/tcp              pyapps9821_web.1.l1497by8nak4k3rjcpqt5e6jt
66ac62b8b6d1        willdocker9821/pyapp9821:v1.0.0   "python app.py"     3 minutes ago       Up 3 minutes        80/tcp              pyapps9821_web.2.id5k92nv3qaciwkb1kx6nw1bd
1e2a9a241db8        willdocker9821/pyapp9821:v1.0.0   "python app.py"     3 minutes ago       Up 3 minutes        80/tcp              pyapps9821_web.3.obs7vdcsl330o2zl89frbxx83
4a37794f1209        willdocker9821/pyapp9821:v1.0.0   "python app.py"     3 minutes ago       Up 3 minutes        80/tcp              pyapps9821_web.4.l6tegao95i33sfoitldbn5j71
```

# docker-compose.yml 
A docker-compose.yml file is a YAML file that defines how Docker containers should behave in production.
```yml
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: willdocker9821/pyapp9821:v1.0.0
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
      - "4000:80"
    networks:
      - webnet
networks:
  webnet:
```

# Swarm
A swarm is a group of machines that are running Docker and joined into a cluster. After that has happened, you continue to run the Docker commands you’re used to, but now they are executed on a cluster by a swarm manager. The machines in a swarm can be physical or virtual. After joining a swarm, they are referred to as nodes.
- cluster
    - machines
        - nodes (manager or worker)
        - workers
            - Workers are just there to provide capacity and do not have the authority to tell any other machine what it can and cannot do.
        - swarm manager
            - container strategy
                - “emptiest node” -- which fills the least utilized machines with containers
                - “global”, which ensures that each machine gets exactly one instance of the specified container.
                - defined in docker-compose.yml
Need to switch docker to swarm mode, which makes current machine a swarm manager.
## Routing Mesh
<img src="https://docs.docker.com/engine/swarm/images/ingress-routing-mesh.png"/>
> Source: https://docs.docker.com/engine/swarm/images/ingress-routing-mesh.png

## Set Up
1. Create Virtual Machines (Hyper-V or VirtualBox)
2. Initialize swarm on one of them (This will be the swarm manager, the others will be workers)
    - `docker-machine ssh myvm1 "docker swarm init --advertise-addr 192.168.1.241"`
    - `docker-machine ssh myvm2 "docker swarm join --token SWMTKN-1-5kv621z11w5pe00ea72wwfnnidkd7vo8k5b2hf2ybeygxwai4o-95lgmwesgmqn98stop50oi7vy 192.168.1.241:2377"`
### Notes when configuring a node
Always run docker swarm init and docker swarm join with port 2377 (the swarm management port), or no port at all and let it take the default.
The machine IP addresses returned by docker-machine ls include port 2376, which is the Docker daemon port. Do not use this port or you may experience errors.

## Issues
Keep in mind that to use the ingress network in the swarm, you need to have the following ports open between the swarm nodes before you enable swarm mode:
Port 7946 TCP/UDP for container network discovery.
Port 4789 UDP for the container ingress network.
Double check what you have in the ports section under your web service and make sure the ip addresses you enter in your browser or curl reflects that

# Docker Registries
A registry is a collection of repositories, and a repository is a collection of images—sort of like a GitHub repository, except the code is already built. An account on a registry can create many repositories. The docker CLI uses Docker’s public registry by default.
- registry
    - repositories
        - images
## Setting Up a Private Repository
https://docs.docker.com/datacenter/dtr/2.2/guides/

# Common Commands
```bash
## List Docker CLI commands
docker
docker container --help

## Display Docker version and info
docker --version
docker version
docker info

## Execute Docker image
docker run hello-world

## List Docker images
docker image ls

## List Docker containers (running, all, all in quiet mode)
docker container ls
docker container ls --all
docker container ls -aq

# Building/Running/Publishing Images
docker build -t friendlyhello .  # Create image using this directory's Dockerfile
docker run -p 4000:80 friendlyhello  # Run "friendlyhello" mapping port 4000 to 80
docker run -d -p 4000:80 friendlyhello         # Same thing, but in detached mode
docker container ls                                # List all running containers
docker container ls -a             # List all containers, even those not running
docker container stop <hash>           # Gracefully stop the specified container
docker container kill <hash>         # Force shutdown of the specified container
docker container rm <hash>        # Remove specified container from this machine
docker container rm $(docker container ls -a -q)         # Remove all containers
docker image ls -a                             # List all images on this machine
docker image rm <image id>            # Remove specified image from this machine
docker image rm $(docker image ls -a -q)   # Remove all images from this machine
docker login             # Log in this CLI session using your Docker credentials
docker tag <image> username/repository:tag  # Tag <image> for upload to registry
docker push username/repository:tag            # Upload tagged image to registry
docker run username/repository:tag                   # Run image from a registry

# Scaling a docker application
# To recap, while typing docker run is simple enough, the true implementation of a container in production is running it as a service. Services codify a container’s behavior in a Compose file, and this file can be used to scale, limit, and redeploy our app. Changes to the service can be applied in place, as it runs, using the same command that launched the service: docker stack deploy.
docker stack ls                                            # List stacks or apps
docker stack deploy -c <composefile> <appname>  # Run the specified Compose file
docker service ls                 # List running services associated with an app
docker service ps <service>                  # List tasks associated with an app
docker inspect <task or container>                   # Inspect task or container
docker container ls -q                                      # List container IDs
docker stack rm <appname>                             # Tear down an application
docker swarm leave --force      # Take down a single node swarm from the manager

# Creating and managing a swarm and its workers
docker-machine create --driver virtualbox myvm1 # Create a VM (Mac, Win7, Linux)
docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm1 # Win10
docker-machine env myvm1                # View basic information about your node
docker-machine ssh myvm1 "docker node ls"         # List the nodes in your swarm
docker-machine ssh myvm1 "docker node inspect <node ID>"        # Inspect a node
docker-machine ssh myvm1 "docker swarm join-token -q worker"   # View join token
docker-machine ssh myvm1   # Open an SSH session with the VM; type "exit" to end
docker node ls                # View nodes in swarm (while logged on to manager)
docker-machine ssh myvm2 "docker swarm leave"  # Make the worker leave the swarm
docker-machine ssh myvm1 "docker swarm leave -f" # Make master leave, kill swarm
docker-machine ls # list VMs, asterisk shows which VM this shell is talking to
docker-machine start myvm1            # Start a VM that is currently not running
docker-machine env myvm1      # show environment variables and command for myvm1
eval $(docker-machine env myvm1)         # Mac command to connect shell to myvm1
& "C:\Program Files\Docker\Docker\Resources\bin\docker-machine.exe" env myvm1 | Invoke-Expression   # Windows command to connect shell to myvm1
docker stack deploy -c <file> <app>  # Deploy an app; command shell must be set to talk to manager (myvm1), uses local Compose file
docker-machine scp docker-compose.yml myvm1:~ # Copy file to node's home dir (only required if you use ssh to connect to manager and deploy the app)
docker-machine ssh myvm1 "docker stack deploy -c <file> <app>"   # Deploy an app using ssh (you must have first copied the Compose file to myvm1)
eval $(docker-machine env -u)     # Disconnect shell from VMs, use native docker
docker-machine stop $(docker-machine ls -q)               # Stop all running VMs
docker-machine rm $(docker-machine ls -q) # Delete all VMs and their disk images
```