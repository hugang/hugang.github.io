# Start the my-jenkins-3 container
docker-compose up -d

# Get the initial admin password
docker exec my-jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# Confirm the my-jenkins-3 container is running
docker ps
