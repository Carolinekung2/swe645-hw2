HW 2: Containerized Static Web App
Course: SWE 645 - Software Engineering for the Web (Dev Ops)
Names: Caroline Kung and Cynthia Kirupakaran
Gnums: ckung4 and ckirupak
Submitted: 06/26/26

Github repo: https://github.com/Carolinekung2/swe645-hw2

- main branch lists Cynthia's docker image in the Jenkinsfile and Deployment.yaml
- carolineDockerImage branch lists Caroline's docker image in the Jenkinsfile and Deployment.yaml (used for Caroline's local testing)

EC2 Website IP address: http://ec2-100-29-137-115.compute-1.amazonaws.com:30080/

HW 2 Documentation
Group: Caroline Kung and Cynthia Kirupakaran
Course: SWE 645 - Software Engineering for the Web (Dev Ops)
Submitted: 06/26/26

Overview:
This assignment consists of a static web app, completed in HW 1, that was containerized with Docker. A docker image of the web app, titled 'carolinekung2/static-web-app' was created and pushed to Docker Hub. An ec2 instance titled 'k8s-cluster-2' was spun up and assigned an elastic ip address (public dns: ec2-100-29-137-115.compute-1.amazonaws.com). Rancher was used to set up a Kubernetes cluster, which was hosted on the ec2 instance. Deployment and Service manifest files were created and the Deployment file defined a replicaSet of 3 replicas. Kubectl was used to deploy the application to Kubernetes and to manually deploy the Deployment and Service files to verify correct deployment before setting up the automated Jenkins pipeline. The kubernetes cluster is deployed onto port 30080, and the web application can be accessed on ec2-100-29-137-115.compute-1.amazonaws.com:30080.

A CI/CD pipeline was set up using Jenkins. A github repo was set up for use in the project: https://github.com/Carolinekung2/swe645-hw2. Jenkins was set up to automate the deployment process and then the app was re-deployed using the automated jenkins process and verified to have correctly deployed.

Troubleshooting:
If the running application cannot be accessed via ec2-100-29-137-115.compute-1.amazonaws.com:30080, make sure your browser has not defaulted to 'https', as 'http' is needed. You can manually change the url back to 'http' or, when prompted with an 'insecure connection' warning, click into the advanced settings and choose to 'proceed anyways'. Most of the work was verified on chrome, so you may additionally want to try switching browsers if you are unable to see the working application on other browsers.

Installation & Setup Instructions

Prerequisites: Docker Desktop, Rancher Desktop, Jenkins
The following commands are runned under each section. The following commands and the working demo are run using Cynthia's copy of the docker image.

1. Clone the repository
   git clone https://github.com/Carolinekung2/swe645-hw2
2. Build and push Docker image
   docker build -t ckirupak/swe645-webapp:latest
   docker push ckirupak/swe645-webapp:latest
3. Start Jenkins
   docker start jenkins
   docker exec -u root jenkins chmod 666 /var/run/docker.sock
   Jenkins runs at http://localhost:8888
4. Deploy to Kubernetes
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   Application runs at http://localhost:30080
5. Verify 3 pods are running
   kubectl get pods

CI/CD Pipeline:
The Jenkins pipeline
Stage 1 – Checkout: Jenkins automatically checks out the latest source code from the GitHub repository.
Stage 2 - Build Docker Image: Docker image is built using Jenkins using the Dockerfile with ckirupak/swe645-webapp:latest.
Stage 3 - Push to Docker Hub: Jenkins logs in to Docker Hub using the credentials saved and pushes the image to the public repository.
Stage 4 – Deploy to Kubernetes: Jenkins runs kubectl apply to update the deployment and service. A trigger starts rolling which pulls the latest image across all 3 pods and the pipeline waits for the rollout to finish before the process completes.
