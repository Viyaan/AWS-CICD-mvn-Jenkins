# jenkins-ci-cd
Demonstrate Jenkins Pipeline as Code


### Installing

A step by step guide to install jenkins in EC2 Linux

```
https://docs.aws.amazon.com/whitepapers/latest/jenkins-on-aws/installation.html
```

Uninstall java 7

```
sudo yum remove java-1.7.0-openjdk
```

Install java 8

```
sudo yum install java-1.8.0-openjdk-devel
```

Install Git

```
sudo yum install git -y
```
Follow the below link

https://scriptcrunch.com/git-clone-error-java-io-ioexception/

Install Docker

```
sudo yum -y install docker
sudo service docker start
sudo chmod 666 /var/run/docker.sock
```


Install SonarQube

```
sudo wget -O /etc/yum.repos.d/sonar.repo http://downloads.sourceforge.net/project/sonar-pkg/rpm/sonar.repo
sudo yum install sonar
sudo service sonar start

```


