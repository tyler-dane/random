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
    - This example uses Maven for the build. Gradle will be covered later
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

### Manually update image, repackage as new image, run docker container
- Make code changes to your `.java` file(s). 
    - In this example, I change "Hello, World" to "Howdy, World"
- `mvn -f myapp/pom.xml clean package`
- `docker build -t hellojava:4`      #package as new image with new tag
- `docker image ls`     #make sure it's there
- `docker container run hellojava:4`    #run image. "Howdy, World" get printed

### Using Docker and Maven
Without Docker
- `cd` to your Java project directory
- `mvn clean package exec:java` #package and run Java app
With Docker
- add `docker-maven-plugin` to `pom.xml` (e.g. the one from `io.fabric8`)
- `mvn package -Pdocker`
- `docker image ls`     #verify it's there
- `mvn install -Pdocker`        #build image, then run container

### Using Docker and Gradle
- Recommended plugin: `gradle-docker-plugin`
- `cd` to Java directory
- `./gradlew build run`     #build and run app with Gradle
- `./gradlew dockerBuildImage`      #default target from plugin
- `docker image ls`     #verify it's there
- `./gradlew startContainer`    #build image, start container (in background)
    - Since it's run in background, STDOUT won't be printed to terminal. 
    - You'll need to get container ID and view logs
- `docker container ls -a`      #get container id 
- `docker container logs <container has>`
    - Output shown here

### Tag and Share Docker Image
- `cd` to your image directory
- `vim Dockerfile`

```
FROM ubuntu:latest

CMD echo "This is v1"
```

- `docker image build .`
- `docker container run <imageID>`  #If you don't want to specify container name
- `docker container run helloworld`
- `docker container ls -a`
- `docker image rm helloworld:latest`   #remove image
    - or `docker container rm -f $(docker container ls -aq)`
- `docker image build -t helloworld:1 .`
- `docker image ls`



### Other
`docker container ls -a`
`docker container rm -f <name>`
`docker container logs <container>`
`docker history <image>`
- Lists specific commands used to create/modify an image
- `docker image rm -f $(docker image ls -aq)` #Remove all existing images


### Reminders
- Only last `CMD` in `Dockerfile` is effective
- `RUN` - used for installing software package
    - One-time commands
- `CMD` - default for executing container; can be overridden from CLI
- `ENTRYPOINT` - configures the container executable
    - Can be overridden using `--entrypoint` from CLI
    - Default value: `/bin/sh -c`
    - `ENTRYPOINT ["/entrypoint.sh"]`   #runs custom script
- `EXPOSE` - network points on which the container is listening
    - `EXPOSE 9990` #exposes port 9990
    - Need to explicitly publish the host port 
    - Still need to use `-p` or `-P` to publish the host port
- `VOLUME` - creates a mount point with the specified name
    - `VOLUME /opt/couchbase/var`
    - `docker container run ... -v ~/data:/opt/couchbase/var` #host dir:container dir
- `USER` - set the UID to use when running the image
- `HEALTHCHECK` - performs healthcheck on the app inside the container
    - `HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail https://localchost:8091/pools || exit 1`
        - Pings REST API every 5s. If fails, sends exit code `

