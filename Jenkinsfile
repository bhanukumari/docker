pipeline {
    agent any

    environment {
        // Set the AWS region and ECR repository URL here
        AWS_DEFAULT_REGION = 'us-east-1'
        ECR_REPO_URL = "public.ecr.aws/v6y7k9w8/jenkins"
        DOCKER_IMAGE_TAG = 'latest'
        CONTAINER_NAME = 'docker-final'
        PORT_MAPPING = '81:80' 
    }

    stages {
        stage('clone') {
       steps {
       git branch: 'main', url: 'https://github.com/bhanukumari/docker'
     }
      }
        stage('Build Docker Image') {
            steps {
                // Assuming you have already built your Docker image earlier in the pipeline
                // Replace 'your-docker-image' with your actual image name and tag
                sh "docker build -t jenkins:${DOCKER_IMAGE_TAG} ."
            }
        }

        stage('Login to ECR') {
            steps {
                // Login to ECR using the AWS CLI and your AWS credentials
                sh "aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/v6y7k9w8"
            }
        }

        stage('Push to ECR') {
            steps {
                // Tag the local Docker image with the ECR repository URL
                sh "docker tag jenkins:${DOCKER_IMAGE_TAG} ${ECR_REPO_URL}:${DOCKER_IMAGE_TAG}"

                // Push the Docker image to ECR
                sh "docker push ${ECR_REPO_URL}:${DOCKER_IMAGE_TAG}"
            }
        }
         stage('check Vulnerability') {
            steps {
                sh "trivy image php > scanning.txt "
            }
        }

        stage('Start Container') {
            steps {
                // Pull the Docker image from ECR
                sh "docker pull ${ECR_REPO_URL}:${DOCKER_IMAGE_TAG}"

                // Start the container using the pulled image
                sh "docker run -d --name ${CONTAINER_NAME} -p ${PORT_MAPPING} ${ECR_REPO_URL}:${DOCKER_IMAGE_TAG}"
            }
        }
        
        stage('Logout to ECR') {
            steps {
                // Login to ECR using the AWS CLI and your AWS credentials
                sh "docker logout public.ecr.aws/v6y7k9w8/jenkins:latest"
            }
        }
        
    }
}
