FROM amazonlinux:2

RUN yum -y update 

# Install AWS CLI v2
RUN yum install -y unzip curl && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip

# Set working directory
WORKDIR /app

# Start container (this keeps the container running for ECS Fargate)
CMD ["tail", "-f", "/dev/null"]