# Docker for Java Developers Tutorial
- This tutorial is based on the **Docker for Java Developers** course on Lynda.com
- Intended audience: Java developers who are new to Docker
- Purpose: Quickly show the steps needed to set up a Java development environment using Docker. 


### Download an image
`docker container run jboss/wildfly`
- Will download the image from Docker Hub

## Using Pre-Existing Containers
### Run a container

`docker container run -it --name web jboss/wildfly bash`
- Replace `-it` for `-d` to run in detached mode
- `bash` sends your to the container's terminal

### Get port image
`docker container ls`

### Map port to host

`docker container run -d --name web -p 8080:8080 jboss/wildfly`

### Map a local directory as a volume in your Docker container
`docker container run -d --name web -p 8080:8080 -v `pwd`/webapp.war:/opt/jboss/wildfly/standalone/deployments/webapp.war jbosss/wildfly`

----

## Create Your Own Container
### Create directory, Dockerfile, and build
`mkdir helloimage`
`cd helloimage`
`vim Dockerfile`

```
FROM ubuntu

CMD echo "hello world"
```

- `docker image build -t helloworld .`
- `docker container run helloworld`

### Build Image for Java Development
`mkdir helloworld`
`cd helloworld`
`vim Dockerfile`

```
FROM openjdk:jdk-alpine     #image:tag (<-- find tag at DockerHub)
CMD java -version
```

### Name& build image, then run container
` docker image build -t hellojava:alpine .`     #setting image tag for organization 
`docker container run hellojava:alpine`
`docker run hellojava:alpine`

### Copy files in the Docker image
- `COPY` = Copy new files/directories to the container filesystem
- `ADD` = Copy; Also allows tar file auto-extraction in the image
    - `ADD app.tar.gz /opt/var/myapp`
- Tip: Use `curl` or `wget` to get tar files from URL, then delete tar file

From your app's Docker directory (/home/src/my/app/):
- `vim Dockerfile`

```
FROM jboss/wildfly

COPY webapp.war /opt/jboss/wildfly/standalone/deployments/webapp.war #container's FS
```

- `docker image build -t helloweb .`
- `docker container run -p 8080:8080 -d helloweb`   #Run container
- `curl http://localhost:8080/webapp/resources/persons` #Verify webapp is up


### Run your own JAR from the Docker image
- Make sure you have an `/app` folder with your Java source code and build file
    - This example uses Maven for the build. Gradel will be covered later
`vim Dockfile`

```
FROM openjdk:jdk-alpine3.7

COPY myapp/target/myapp-1.0-SNAPSHOT.jar /deployments/

CMD java -jar /deployments/myapp-1.0-SNAPSHOT.jar
```

- `mvn -f myapp/pom.xml clean package`
    - Make the `myapp-1.0-SNAPSHOjar` that was referenced in the `Dockerfile`
- `docker build -t hellojava:3 .`   #build image
- `docker container run hello:java3`

### Update image, repackage as new image, run docker container
- Make code changes to your `.java` file(s). 
    - In this example, I change "Hello, World" to "Howdy, World"
- `mvn -f myapp/pom.xml clean package`
- `docker build -t hellojava:4`      #package as new image with new tag
- `docker image ls`     #make sure it's there
- `docker container run hellojava:4`    #run image. "Howdy, World" get printed



### Other
`docker container ls -a`
`docker container rm -f <name>`
`docker container logs <container>`
`docker history <image>`
- Lists specific commands used to create/modify an image


### Reminders
- Only last `CMD` in `Dockerfile` is effective
