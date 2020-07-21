FROM debian:buster

RUN apt-get update -y
RUN apt-get install -y nginx mariadb-server php-fpm php-mysql php-mbstring

COPY ./srcs/websources/wordpress.tar.gz /tmp/
COPY ./srcs/websources/phpmyadmin.tar.gz /tmp/

COPY ./srcs/nginxconf/default /etc/nginx/sites-available/default
COPY ./srcs/nginxconf/nginx.conf /etc/nginx/nginx.conf

RUN tar xzf /tmp/wordpress.tar.gz --strip-components=1 -C /var/www/html;tar xzf /tmp/phpmyadmin.tar.gz --strip-components=1 -C /var/www/html

RUN mkdir /etc/nginx/ssl
COPY ./srcs/ssl /etc/nginx/ssl
COPY ./srcs/sql/wordpress.sql /tmp

RUN cd /etc/nginx/ssl/;chmod +x mkcert;./mkcert localhost;
RUN service mysql start;mysql -u root -ptoor < tmp/wordpress.sql;

RUN chown -Rv www-data:www-data /var/www/html
RUN rm /var/www/html/index*;cd /tmp/;rm -r *;rm -r /etc/nginx/ssl/mkcert;apt-get clean;

EXPOSE 80
EXPOSE 443
CMD service mysql start;service php7.3-fpm start;service nginx start;tail -f /dev/null;