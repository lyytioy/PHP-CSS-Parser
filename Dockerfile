# bullseye is debian 11
FROM debian:bullseye-backports

# Opens HTTP Ports
EXPOSE 443

# Adds lyyti user
RUN useradd lyyti

# Sets environment variables
ENV DEBIAN_FRONTEND "noninteractive"

# Enable contrib and non-free, required for ttf-mscorefonts-installer
RUN sed 's/ main/ main contrib non-free/' -i /etc/apt/sources.list

RUN apt-get --fix-missing update

# Enable https support for wget and cert support for apt
RUN apt-get install --no-install-recommends -y lsb-release gnupg2 apt-transport-https ca-certificates wget curl

RUN curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg \
    && sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

# Update sources list and upgrade preinstalled packages
RUN apt-get update && apt-get upgrade -y

# Updates again
RUN apt-get update

RUN apt-get install -y \
    php8.2 \
    php8.2-mbstring \
    php8.2-dom

# Composer
RUN wget https://getcomposer.org/download/2.6.6/composer.phar -O /usr/bin/composer.phar
# Our composer.json is under /home/lyyti/lyyti/laravel
# so we create our own composer script that only runs in that directory no matter where you run it from
RUN echo "#!/usr/bin/env bash" >> /usr/bin/composer ; \
    echo "php /usr/bin/composer.phar \$@" >> /usr/bin/composer ; \
    chmod 755 /usr/bin/composer ;

# reduces image size
RUN apt-get clean

WORKDIR "/php-css-parser"

CMD sleep infinity
