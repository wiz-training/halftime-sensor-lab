FROM php:7.2.10-fpm

# Disable other repositories and use archived Debian repositories
RUN echo 'deb http://archive.debian.org/debian stretch main' > /etc/apt/sources.list && \
    echo 'deb http://archive.debian.org/debian-security stretch/updates main' >> /etc/apt/sources.list && \
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true && \
    apt-get install -y --allow-unauthenticated sudo less unzip && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user and add specific sudo privileges
RUN echo 'www-data ALL=(ALL) NOPASSWD: /usr/local/bin/php' >> /etc/sudoers 

# Copy website files
COPY src/www /var/www/html

# Expose the port
EXPOSE 9000
