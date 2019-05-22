# instagram_stories_backup

Sample argurment:
```
user: docker
login_account: docker
login_password: docker
bucket_name: docker
```
1. Create an AWS EC2 instance with the bootstrap script, an IAM S3-access role and a S3 bucket
```
#!/bin/bash
yum update -y
yum install docker git -y
service docker start
chkconfig docker on
usermod -a -G docker ec2-user
```
2. Clone the repository
```
git clone https://github.com/giang-vu/instagram_stories_backup.git
```
3. Build your Docker image
```
cd instagram_stories_backup
docker build -t gvu0110/instagram:v1 --build-arg user=docker --build-arg login_account=docker --build-arg login_password=docker --build-arg bucket_name=docker .
```
4. Run Docker container
```
docker run -it --name instagram -d gvu0110/instagram:v1 bash
```
5. Send a cron start trigger to the container because cron does not start automatically
```
docker exec -it instagram cron
```
