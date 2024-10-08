FROM php:7.2.10-fpm

# Disable other repositories and use archived Debian repositories
RUN echo 'deb http://archive.debian.org/debian stretch main' > /etc/apt/sources.list && \
    echo 'deb http://archive.debian.org/debian-security stretch/updates main' >> /etc/apt/sources.list && \
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true && \
    apt-get install -y --allow-unauthenticated sudo less unzip jq && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user and add specific sudo privileges
RUN echo 'www-data ALL=(ALL) NOPASSWD: /usr/local/bin/php' >> /etc/sudoers 

# Copy website files
COPY src/www /var/www/html

# Copy the credentials file into the image
COPY src/credentials /root/.aws/credentials

# Set permissions so that only root can access the credentials
RUN chown -R root:root /root/.aws/credentials && chmod 600 /root/.aws/credentials

# Install aws-cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \ 
    sudo ./aws/install && \
    rm -rf awscliv2.zip aws

# Expose the port
EXPOSE 9000
