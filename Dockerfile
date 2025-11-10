# Use official PHP image with Apache
FROM php:8.2-apache

# Set working directory inside container
WORKDIR /var/www/html

# Copy all project files into the container
COPY . .

# Install required system packages and PHP extensions
RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    oniguruma-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl gd

# Enable Apache mod_rewrite (for Laravel routing)
RUN a2enmod rewrite

# Set Apache DocumentRoot to Laravel's public directory
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Set proper permissions for Laravel storage and cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 80 to Render
EXPOSE 80

# Run Composer to install dependencies
# (If composer.json exists, install dependencies)
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && composer install --no-dev --optimize-autoloader --no-interaction

# Generate Laravel key (Render can handle this via environment)
# CMD below ensures key is generated on first start if missing
CMD php artisan key:generate --force && apache2-foreground
