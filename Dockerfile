#
# Ubunut-based PHP LEMP stack
#
#
# Building:
# docker build -t kmrd/lemp .
#
#
# Usage:
# ------------------
# OSX / Ubuntu:
# docker run -it --rm --name lemp -p 80:80 --mount type=bind,source=$(PWD),target=/var/www/html/ kmrd/lemp
#
# Windows:
# docker run -it --rm --name lemp -p 80:80 --mount type=bind,source="%cd%",target=/var/www/html/ kmrd/lemp
#
#
FROM ubuntu:16.04
MAINTAINER David Reyes <david@thoughtbubble.ca>

# Environments vars
ENV TERM=xterm
ENV DEBIAN_FRONTEND noninteractive 


#-----------------------#
# Installs              #
#-----------------------#

RUN apt-get -y update && \
    apt-get -y upgrade


RUN apt-get -y --fix-missing install \
      curl \
      apt-transport-https \
      git \
      nano \
      lynx-cur \
      sudo \
      lsof \
      dos2unix \
      unzip \
      nodejs \
      nodejs-legacy \
      npm


# Install supervisor (not strictly necessary)
RUN apt-get -y --fix-missing install supervisor && \
      mkdir -p /var/log/supervisor


# Install nginx (full)
RUN apt-get install -y nginx-full


# Install PHP
RUN apt-get -y --fix-missing install \
      php7.0 \
      php7.0-cli \
      php-fpm \
      php7.0-gd \
      php7.0-json \
      php7.0-mbstring \
      php7.0-xml \
      php7.0-xsl \
      php7.0-zip \
      php7.0-soap \
      php-pear \
      php-sqlite3 \
      php7.0-curl


# Install MySQL
RUN apt-get -y --fix-missing install \
      mysql-server \
      mysql-client \
      php-mysql


# Install LESS package
RUN npm install -g less


#-----------------------#
# Configurations        #
#-----------------------#
# Configure nginx default site
ADD conf/default /etc/nginx/sites-available/default


# Configure php.ini
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/display_errors\s*=\s*Off/display_errors = On/g" /etc/php/7.0/fpm/php.ini

# RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Setting Permissions
RUN chown -R www-data:www-data /var/www/html

VOLUME /var/www/html

WORKDIR /var/www/html

EXPOSE 80
EXPOSE 443


#-----------------------#
# Final Action          #
#-----------------------#
# Use entrypoint script
ADD conf/entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

#Start nginx
# RUN nginx
# CMD ["nginx", "-g", "daemon off"]

#Start supervisor
# CMD ["/usr/bin/supervisord"]


#CMD ["/bin/bash"]







#CMD ["nginx"]

# CMD ["nginx", "-g", "daemon off"]

# Composer install
# RUN curl -sS https://getcomposer.org/installer | php
# RUN mv composer.phar /usr/local/bin/composer
