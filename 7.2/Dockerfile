FROM php:7.2-apache
MAINTAINER Tangent Solutions <zander@tangentsolutions.co.za>

COPY init.sh /bin/

# Configure Apache Modules
RUN a2enmod rewrite expires include deflate headers

# Install PHP Modules
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        libldap2-dev \
        libcurl4-gnutls-dev \
        curl \
        libicu-dev \
        libmcrypt-dev \
        libvpx-dev \
        libjpeg-dev \
        libpng-dev \
        libxpm-dev \
        zlib1g-dev \
        libfreetype6-dev \
        libxml2-dev \
        libexpat1-dev \
        libbz2-dev \
        libgmp3-dev \
        libldap2-dev \
        unixodbc-dev \
        libpq-dev \
        libsqlite3-dev \
        libaspell-dev \
        libsnmp-dev \
        libpcre3-dev \
        libtidy-dev \
        build-essential \
        libkrb5-dev \
        libedit-dev \
        libedit2 \
        gcc \
        make \
        python2.7-dev \
        python-pip \
        re2c \
        wget \
        sqlite3 \
        libmemcached-dev \
        libc-client-dev -yqq \
        openssh-server \
    && echo "root:Docker!" | chpasswd \
    && echo "cd /home" >> /etc/bash.bashrc \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
    && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install redis \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install mbstring \
         pdo_mysql \
         json \
         intl \
         gd \
         xml \
         zip \
         bz2 \
         opcache \
         pgsql \
         pdo_sqlite\
         intl \
         bcmath \
         soap \
         ldap \
         readline \
    && docker-php-ext-enable redis

# ImageMagick
RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends
RUN pecl install imagick && docker-php-ext-enable imagick

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
