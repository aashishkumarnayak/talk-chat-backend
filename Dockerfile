# Use the official PHP image with Apache
FROM php:8.2-apache

# Set working directory inside container
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy composer from the composer image (avoids installing globally)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy Laravel project files
COPY . .

# ✅ Copy your .env file before running composer or artisan commands
# Make sure .env exists in your repo root
COPY .env /var/www/html/.env

# Install dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Set correct permissions for storage and cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Set Apache document root to Laravel's public folder
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Expose port 80
EXPOSE 80

# Generate application key (only if not already set)
RUN php artisan key:generate --ansi || true

# Start Apache server
CMD ["apache2-foreground"]
