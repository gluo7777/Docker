- Swarm
    - Stack
    - node
        - manager
        - worker
        - Container

# Development
# Package App Source Code
# Build Image
- Create Dockerfile and place in directory with all source code
- Visit https://hub.docker.com to find images.
- Create docker-compose.yml
- Build Image: `docker build -t pyapp9821:v1.2.0 .` in Dockerfile directory
- (Optional) Tag latest: `docker tag pyapp9821:v1.2.0 username/repository:latest`
- Check Image Created: `docker image ls -a`. Note: latest and your most recent version should have the same IMAGE ID.
# Publish Image
- Create a copy of image by tagging it and change format to username/repository:tag
    - `docker tag <image> username/repository:tag`
- Push to DockerHub or configured repository: `docker push username/repository:tag`
- visit `https://hub.docker.com/` to check your repository.
- (Optional) Push latest: `docker tag pyapp9821:v1.2.0 username/repository:latest`
- (Optional) Run image locally: `docker run username/repository:tag` or `docker run -p extport:intport username/repository:tag`
# Initialize a swarm cluster
- Run with full admin/sudo rights
- Provision VMs with Hypervisor/VirtualBox as needed
## Designate Swarm Manager
- On manager, initialize swarm: `docker swarm init`
- Copy output and run on any workers to add to swarm.
## Deploy Stack
- Expose swarm manager machine's environment to run locally: `& docker-machine" env myvm1 | Invoke-Expression` or copy docker-compose.yml to myvm1.
- On manager, Deploy using docker-compose.yml: `docker stack deploy -c <composefile> <appname>`
- On manager, find IP and test end points: `docker-machine ls`