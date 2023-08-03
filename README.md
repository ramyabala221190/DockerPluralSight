1. What is docker ?
Simplifies building ,shipping code to different environments and runnning apps.
Relies on Images and Containers.
Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. 

Docker provides the ability to package and run an application in a loosely isolated environment called a container. The isolation and security allows you to run many containers simultaneously on a given host. Containers are lightweight and contain everything needed to run the application, so you do not need to rely on what is currently installed on the host. You can easily share containers while you work, and be sure that everyone you share with gets the same container that works in the same way.

2. What is an image ?
An image is a read-only template with instructions for creating a Docker container. Often, an image is based on another image, with some additional customization.

To build your own image, you create a Dockerfile with a simple syntax for defining the steps needed to create the image and run it. Each instruction in a Dockerfile creates a layer in the image. When you change the Dockerfile and rebuild the image, only those layers which have changed are rebuilt. This is part of what makes images so lightweight, small, and fast, when compared to other virtualization technologies.

Image is something which is used to build a running container. Image will have the necessary files
to run something on the OS.

3. What is a container ?
A container is a runnable instance of an image. You can create, start, stop, move, or delete a container using the Docker API or CLI. 

By default, a container is relatively well isolated from other containers and its host machine. You can control how isolated a container’s network, storage, or other underlying subsystems are from other containers or from the host machine.

A container is defined by its image as well as any configuration options you provide to it when you create or start it. When a container is removed, any changes to its state that are not stored in persistent storage disappear.

4. Docker client,Docker Daemon and Docker Registry

Docker uses a client-server architecture. The Docker client talks to the Docker daemon, which does the heavy lifting of building, running, and distributing your Docker containers. 

The Docker daemon (dockerd) listens for Docker API requests and manages Docker objects such as images, containers, networks, and volumes. A daemon can also communicate with other daemons to manage Docker services.

The Docker client (docker) is the primary way that many Docker users interact with Docker. When you use commands such as docker run, the client sends these commands to dockerd, which carries them out. The docker command uses the Docker API. The Docker client can communicate with more than one daemon.

A Docker registry stores Docker images. Docker Hub is a public registry that anyone can use, and Docker is configured to look for images on Docker Hub by default. You can even run your own private registry.

When you use the docker pull or docker run commands, the required images are pulled from your configured registry. When you use the docker push command, your image is pushed to your configured registry.




First run the angular build

docker build -t angular-image

you need to -f also if you are running from a file other than the default Dockerfile
This creates the image.

To run the image:

docker run -p [host port:container port] -v ${pwd}/dist:usr/share/nginx/html <image-name>
So if we wanted to expose port 8000 inside the container to port 3000 outside the container, 
we would pass 3000:8000 to the --publish flag.

It means host port is the port on which the angular appln will run
container port is the port on which the nginx server is running

Advantage of volume:

Without -v Everytime the code changes, you need to rebuild and rerun the image

By adding the -v, we just need to rebuild the angular app in another tab using ng build and
nginx will automatically take the new changes

Multi Stage Docker file

1. Build the application. This will create an intermediate image.
2. Copy code and create server. This will create 2nd image.
3. Final image will be very small.


https://github.com/DanWahlin/Angular-Core-Concepts/blob/main/config/nginx.conf

Important commands to clean up the system:
docker ps -a
docker system prune
docker rmi <image name>

docker-compose uses the docker-compose.yml file to build the image and to run the containers
Its mainly used to run multiple containers eg: angular and any server side framework.
If not needed we need to manually enter the docker build and docker run commands.
Not using the compose file. Just included in the project for info.

The server folder is only required if you have the server config also in the same project.
A container registry contains docker images.
