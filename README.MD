## Meru Infrastructure

Evaluate skills in systems administration, automation, and infrastructure management using core DevOps
infrastructure using core DevOps technologies such as AWS, Docker, Kubernetes, Linux,
Networking and Terraform.


1. Infrastructure Approvisioning using Terraform in AWS

- Using Terraform, create a basic environment on AWS that includes:
    o An EC2 instance running Linux.
    o A Security Group that allows SSH (port 22) and HTTP (port 80) access.
    (port 80).
    o A public IP address assigned to the EC2 instance.

- Make sure that the Terraform configuration file is modular and can be reused to deploy multiple instances.
to deploy multiple instances.

2.  Containerization and Deployment

- Create a Dockerfile that builds a Docker image for a simple web application (it can be a basic Python Flask or Node.js web application, for example).

- The Docker image should expose the application on port 80.

- Create a docker-compose.yml file that allows the application to run in a container

3. Kubernetes Container Deployment

- Create a Kubernetes manifest (deployment.yml) that deploys the Dockerized application to a Kubernetes cluster.

- Configure a LoadBalancer Service that exposes the application on a port accessible from outside the cluster.

4. Linux Network and Security Configuration

- On the EC2 instance created in Task 1, perform the following configurations:

    o Configure firewall rules (using iptables or ufw) to ensure that only traffic on ports 22 and 80 is allowed.
    traffic is only allowed on ports 22 and 80.
    o Configure SSH to allow access with SSH keys only and disable password authentication.
    password authentication.
    o Install and configure Nginx as a reverse proxy that redirects HTTP traffic to port 80 of the web application inside the Docker container.
    the web application inside the Docker container.
