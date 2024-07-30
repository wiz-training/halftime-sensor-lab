# Base image
FROM php:7.2.10-fpm

# Disable other repositories and use archived Debian repositories
RUN echo 'deb http://archive.debian.org/debian stretch main' > /etc/apt/sources.list && \
    echo 'deb http://archive.debian.org/debian-security stretch/updates main' >> /etc/apt/sources.list && \
    apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::AllowInsecureRepositories=true && \
    apt-get install -y --allow-unauthenticated sudo less unzip nginx && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user and add specific sudo privileges
RUN echo 'www-data ALL=(ALL) NOPASSWD: /usr/local/bin/php' >> /etc/sudoers 

# Copy custom configuration file
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy website files
COPY www /var/www/html
COPY www /usr/share/nginx/html

# Configure entrypoint
COPY entrypoint.sh /etc/entrypoint.sh

RUN chmod +x /etc/entrypoint.sh

# Expose the ports
EXPOSE 80

# Start Supervisor
#ENTRYPOINT ["/etc/entrypoint.sh"]
