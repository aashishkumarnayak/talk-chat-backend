# Use official PHP image with Apache
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Enable Apache rewrite module (needed for Laravel routing)
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html/public

# Copy composer and install dependencies
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy all files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set permissions for Laravel storage and cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy environment example
COPY .env.example .env

# Generate application key (optional if done manually)
RUN php artisan key:generate

# Expose port 80 for web traffic
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
