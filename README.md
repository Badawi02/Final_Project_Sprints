# Final_Project_Sprints
## Tools Used
 - AWS
 - Terraform
 - Docker
 - Docker-compose
 - Kubernates
 - ansible
 - Jenkins
 - Bash script

### Project Details:

 - Infrastructure as code using Terraform that builds an environment on AWS
 - make docker-compose on EC2 and access the app form 
    - http://<public_ip for ec2>:5002
 - install jenkins on EC2 using ansible
 - access jenkins from > http://<public_ip for ec2>:8080
 - make ci/cd with jenkins :
     - Dockerizing a flask app with mysql database and push it to ECR
     - Deploy the app with Kubernetes 

### Getting Started

- Download The Code

```bash
  git clone https://github.com/Badawi02/Final_Project_Sprints.git
```
- Setup your AWS account credentials
```bash
  aws configure
```
-----------------------------------------------------------------------------------------
### Create key on your AWS account named "ec2_key" and download it in folders "terraform" & "ansible"
-----------------------------------------------------------------------------------------
### Build the Infrastructure
```bash
  cd terraform
```
```bash
  terraform init
```
```bash
  terraform apply
```
Output:
![agent](https://github.com/Badawi02/Final_Project_Sprints/blob/main/ScreenShots/0.png)

Now you can check your AWS account, you can see this resources has been created:
- 1 VPC named "vpc-main".
- 2 Subnets .
- 1 Internet gateway
- 1 security group 
- 1 routing table
- Public EC2 in subnet to manage the cluster.
- Private Kubernetes cluster (EKS) with 2 worker nodes.
- 2 ECR "flask_app" "mysql_db"


##  Connect EC2 on Private Kubernetes cluster (EKS) :
-  Enter your AWS account credentials 
```bash
  aws configure
```
-  Connect clutser by EC2
```bash
  aws eks --region us-east-1 update-kubeconfig --name cluster
```



##  Make docker-compose for test the app :
-   fist , SSH on the EC2 
-   git clone for the repo on machine 
```bash
  git clone https://github.com/Badawi02/Final_Project_Sprints.git
```
-   enter the path Final_Project_Sprints/Flask_Mysql_app/
-   RUN
```bash
    sudo usermod -aG docker $USER
    newgrp docker
    docker-compose up
```
Output:
![agent](https://github.com/Badawi02/Final_Project_Sprints/blob/main/ScreenShots/1.png)
-  then , can access app from browser
```bash
    http://<public_ip for ec2>:5002
```
Output:
![agent](https://github.com/Badawi02/Final_Project_Sprints/blob/main/ScreenShots/2.png)


## Install Jenkins on EC2 with ansible :
- first, Put public ip of EC2 in inventory file
- Run 
```bash
    cd ansible
    ansible-playbook -i inventory --private-key ec2_key.pem install_jenkins.yml
```
Output:
![agent](https://github.com/Badawi02/Final_Project_Sprints/blob/main/ScreenShots/3.png)
-  then , can access jenkins from browser
```bash
    http://<public_ip for ec2>:8080
```

## Make pipleline :
- Put the init password that output from ansible in browser
- install suggested plugins
- create account on jenkins
- install "cloudbees aws credentials" plugin
Output:
![agent](https://github.com/Badawi02/Final_Project_Sprints/blob/main/ScreenShots/4.png)
- create credentials for AWS account in aws credentials and name it "aws_cred"
- create credentials for github account in username and password
- create credentials for userId for AWS account in secret text name it "user_id"
Output:
![agent](https://github.com/Badawi02/Final_Project_Sprints/blob/main/ScreenShots/6.png)
- create pipeline multibranch
- cofigure the pipe line to get code from github
Output:
![agent](https://github.com/Badawi02/Final_Project_Sprints/blob/main/ScreenShots/7.png)
- configure github account in webhook and put :

```bash
    http://<public_ip for ec2>:8080/github-webhook/
```
Output:
![agent](https://github.com/Badawi02/Final_Project_Sprints/blob/main/ScreenShots/8.png)

- the pipeline will tragger branches and will build the pipeline
Output:
![agent](https://github.com/Badawi02/Final_Project_Sprints/blob/main/ScreenShots/9.png)
## Deploying app to Kubernetes with jenkins :
- first, SSH to EC2
- Run 
```bash
    kubectl get all -n ingress-nginx
```
That will deploy:
- Config Map for environment variables
- Mysql statefulset and Exopse it with ClusterIP service
- PV and PVC as storge for database
- Flask App Deployment and Exopse it with NodePort service
- ingress nginx controller
- ingress for routing the app
- You can show all resources of cluster
Output:
![agent](https://github.com/Badawi02/Final_Project_Sprints/blob/main/ScreenShots/10.png)
## Now, you can access the Flask App by hitting the Loadbalancer 
Output:
![agent](https://github.com/Badawi02/Final_Project_Sprints/blob/main/ScreenShots/11.png)

## Contributors:
- [Ahmed Badawi](https://github.com/Badawi02)
