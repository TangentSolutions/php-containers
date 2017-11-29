FROM php:7.1-apache
MAINTAINER Tangent Solutions <zander@tangentsolutions.co.za>

COPY init.sh /bin/

# Configure Apache Modules
RUN a2enmod rewrite expires include deflate headers

# Install PHP Modules
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         libpng12-dev \
         libjpeg-dev \
         libpq-dev \
         libmcrypt-dev \
         libldap2-dev \
         libldb-dev \
         libicu-dev \
         libgmp-dev \
         libmagickwand-dev \
         openssh-server vim curl wget tcptraceroute \
    && echo "root:Docker!" | chpasswd \
    && echo "cd /home" >> /etc/bash.bashrc \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick redis \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd \
         mysqli \
         opcache \
         pdo \
         pdo_mysql \
         pdo_pgsql \
         pgsql \
         ldap \
         intl \
         mcrypt \
         gmp \
         zip \
         bcmath \
         mbstring \
         pcntl \
    && docker-php-ext-enable imagick redis

# Configure Directories
RUN   \
   rm -fr /var/log/apache2 \
   && rmdir /var/lock/apache2 \
   && rmdir /var/run/apache2 \
   && chmod 777 /var/log \
   && chmod 777 /var/run \
   && chmod 777 /var/lock \
   && chmod 755 /bin/init.sh \
   && mkdir -p /home/LogFiles \
   && rm -rf /var/www/html \
   && ln -s /home/site/wwwroot /var/www/html \
   && ln -s /home/LogFiles /var/log/apache2

# Configure Apahce Conf
COPY apache2.conf /etc/apache2/apache2.conf

# Configure Opcache
RUN { \
                echo 'opcache.memory_consumption=128'; \
                echo 'opcache.interned_strings_buffer=8'; \
                echo 'opcache.max_accelerated_files=4000'; \
                echo 'opcache.revalidate_freq=60'; \
                echo 'opcache.fast_shutdown=1'; \
                echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Configure PHP INI
RUN { \
                echo 'error_log=/var/log/apache2/php-error.log'; \
                echo 'display_errors=Off'; \
                echo 'log_errors=On'; \
                echo 'display_startup_errors=Off'; \
                echo 'date.timezone=UTC'; \
                echo 'expose_php=Off'; \
                echo 'allow_url_fopen=Off'; \
                echo 'allow_url_include=Off'; \
                echo 'disable_functions=exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source'; \
    } > /usr/local/etc/php/conf.d/php.ini

# Enable Kudu SSH
COPY sshd_config /etc/ssh/

# Fix User Permissions
RUN usermod -u 1000 www-data

EXPOSE 2222 8080

# Environment Settings
ENV APACHE_RUN_USER www-data
ENV PORT 8080
ENV WEBSITE_ROLE_INSTANCE_ID localRoleInstance
ENV WEBSITE_INSTANCE_ID localInstance
ENV PATH ${PATH}:/home/site/wwwroot

WORKDIR /var/www/html

ENTRYPOINT ["/bin/init.sh"]
