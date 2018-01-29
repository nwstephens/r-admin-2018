# Other notes

Getting started

## Server

* http://54.149.163.100

## AWS Setup

* Choose an AMI
* Ubuntu
* Size - 2 core 4 GB

## Security group

* port 8787
* port 3939
* port 80

## pem key

* ssh into box

## Config

```{bash}
sudo apt-get update
sudo useradd -m rstudio
sudo echo "rstudio:rstudio" | chpasswd
```

## Integration points

1. Email
2. Git
3. Database
4. Webserver/CMS
5. Auth
6. API
