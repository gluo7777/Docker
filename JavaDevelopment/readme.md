# Followed Tutorial Here:
https://spring.io/guides/gs/spring-boot-docker/
Maven plugin requires you to expose your docker daemon on a port. I think that's more trouble than it's worth, so I'm just gonna run with docker CLI.
https://www.baeldung.com/dockerizing-spring-boot-application

# Building Image
> docker image build -f spring-boot.dockerfile -t willdocker9821/spring-boot-demo:v1.0.0 .

# Create volume (for persistence)
> docker volume create --name=

# Running Image as a Container
> docker run --volume=dockerapp:/tmp -p 8080:8080 willdocker9821/spring-boot-demo

# Uploading Image
> docker image push willdocker9821/spring-boot-demo

# Scaling
```bash
# Init Swarm as Manager
docker swarm init
# Create Stack
docker stack deploy -c docker-compose.yml spring-boot-demos
# Check port mapped correctly
docker ps
```

# Testing
> curl localhost:9090