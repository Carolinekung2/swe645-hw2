# use the official Nginx image as the base image
FROM nginx:alpine

# remove the default Nginx static content
RUN rm -rf /usr/share/nginx/html/*

# copies your custom index.html file from your local directory into the container's Nginx web root directory
COPY ./ /usr/share/nginx/html/

# Exposes port 80 for the HTTP server
EXPOSE 80

# Runs the Nginx server and ensures it doesn’t run as a background process.
CMD ["nginx", "-g", "daemon off;"]