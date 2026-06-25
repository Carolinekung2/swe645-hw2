// Jenkinsfile
// Authors: Caroline Kung, Cynthia Kirupakaran
// Course: SWE645 - Software Engineering for the Web
// Purpose: CI/CD pipeline for SWE645 Assignment 2. Builds a Docker image, pushes it to Docker Hub, and redeploys
//          the application on a Kubernetes cluster using kubectl.

pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'carolinekung2/static-web-app'
        DOCKER_TAG   = 'latest'
    }

    stages {

        stage('Checkout') {
            steps {
                // Pull the latest source code from GitHub
                checkout scm
                echo "Source code checked out from GitHub."
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // 'dockerhub-credentials' must be configured in Jenkins > Manage Credentials
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                        echo "Docker image pushed to Docker Hub."
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Deploying to Kubernetes cluster..."
                    // Apply deployment and service manifests
                    sh "kubectl apply -f deployment.yaml"
                    sh "kubectl apply -f service.yaml"
                    // Force pods to pull the new image
                    sh "kubectl rollout restart deployment/swe645-deployment"
                    // Wait for rollout to finish
                    sh "kubectl rollout status deployment/swe645-deployment"
                    echo "Deployment complete! Application is live."
                }
            }
        }

    }

    post {
        success {
            echo "Pipeline completed successfully. Application is live on Kubernetes."
        }
        failure {
            echo "Pipeline failed. Check the stage logs above for errors."
        }
    }
}
