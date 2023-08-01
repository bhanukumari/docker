# Specify the base image with PHP and Apache
FROM php:8.0-apache

# Set the working directory inside the container
WORKDIR /var/www/html

COPY index.php /var/www/html/index.php
# Install additional PHP extensions and dependencies required for your PHP application
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd mysqli pdo pdo_mysql zip

# Enable Apache rewrite module
RUN a2enmod rewrite

# Copy necessary configuration files to the appropriate locations inside the container
ADD php.ini /usr/local/etc/php/php.ini
COPY blogsite.com.conf /etc/apache2/sites-available/
COPY hosts /etc/hosts

# Enable the Apache site
RUN a2ensite blogsite.com

# Expose port 80 for accessing the PHP application
EXPOSE 80

# Restart Apache to apply the changes
CMD ["apache2-foreground"]
