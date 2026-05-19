# Use the official PHP Apache image
FROM php:8.2-apache

# Install required PHP extensions for Joomla and the Downloader script
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite module
RUN a2enmod rewrite

# Fix the conflicting MPM error (ensuring only mpm_prefork is loaded)
RUN a2dismod mpm_event mpm_worker || true && a2enmod mpm_prefork

# Set working directory to the webroot
WORKDIR /var/www/html

# Download the specific script directly into the container's web root
ADD https://githubusercontent.com /var/www/html/joomla_downloader.php

# Grant Apache ownership permissions
RUN chown -w /var/www/html && chown -R www-data:www-data /var/www/html

# Expose standard port
EXPOSE 80
