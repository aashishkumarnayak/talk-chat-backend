# Use official PHP with Apache
FROM php:8.2-apache

# Set working directory inside the container
WORKDIR /var/www/html

# Install required system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy all project files to container
COPY . .

# Install Composer globally
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Enable Apache mod_rewrite for Laravel routes
RUN a2enmod rewrite

# Set Apache DocumentRoot to Laravel’s public folder
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Set permissions for Laravel storage and cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 80 for Render
EXPOSE 80

# Generate key and start Apache
CMD php artisan key:generate --force && apache2-foreground
