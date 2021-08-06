FROM centos:8 AS builder

RUN dnf update -y
RUN dnf install -y git
RUN dnf install maven -y
RUN dnf install java-1.8.0-openjdk -y

RUN mkdir /task
RUN chmod 755 /task
RUN git clone http://10.26.1.37/ulia/lavagna.git /task

WORKDIR /task
#COPY pom.xml pom.xml

RUN mvn package

FROM tomcat:8.5-jdk8
COPY --from=builder /task/target/lavagna.war /lavagna/ROOT.war
RUN cp /lavagna/ROOT.war /usr/local/tomcat/webapps/
