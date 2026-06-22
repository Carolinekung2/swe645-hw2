# Dockerfile
# Authors: Caroline Kung, Cynthia Kirupakaran
# Course: SWE645 - Software Engineering for the Web
# Purpose: Containerizes the SWE645 web application (homepage + survey) using nginx.
#          The built image is pushed to Docker Hub and deployed to Kubernetes for Assignment 2.

# Use the official Nginx image as the base image
FROM nginx:alpine

# Remove the default Nginx placeholder content
RUN rm -rf /usr/share/nginx/html/*

# Copy all web application files into the nginx html directory
COPY index.html /usr/share/nginx/html/
COPY survey.html /usr/share/nginx/html/
COPY csInfo.html /usr/share/nginx/html/
COPY carolineHeadshot.jpg /usr/share/nginx/html/

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start nginx in the foreground (required for Docker containers)
CMD ["nginx", "-g", "daemon off;"]