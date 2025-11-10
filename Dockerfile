# Use official PHP + Apache image
FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install dependencies and extensions
RUN apt-get update && apt-get install -y \
    git unzip zip libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev curl \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Enable Apache rewrite module
RUN a2enmod rewrite

# Copy Composer binary
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy app files
COPY . .

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Update Apache document root to public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf
RUN php artisan config:clear && php artisan cache:clear && php artisan route:clear
RUN php artisan migrate
EXPOSE 80

CMD ["apache2-foreground"]
