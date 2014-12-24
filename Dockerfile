FROM centos:latest
 
MAINTAINER Matt McCormick <mjmccorm@gmail.com>
 
#RUN yum update
#RUN yum -y upgrade
 
# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
#RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl curl lynx-cur
RUN yum -y install httpd

# Enable apache mods.
#RUN a2enmod php5
#RUN a2enmod rewrite
 
# Update the PHP.ini file, enable <? ?> tags and quieten logging.
#RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
#RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini
 
# Manually set up the apache environment variables
#ENV APACHE_RUN_USER www-data
#ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/httpd
#ENV APACHE_LOCK_DIR /var/lock/apache2
#ENV APACHE_PID_FILE /var/run/apache2.pid
 
EXPOSE 80
 
# Copy site into place.
ADD www /var/www/site
 
# Update the default apache site with the config we created.
#ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
ADD apache-config.conf /etc/httpd/conf.d/mysite.conf

# By default, simply start apache.
#CMD /usr/sbin/apachectl -D FOREGROUND
#CMD /usr/bin/httpd -D FOREGROUND
#RUN /usr/sbin/apachectl
# Simple startup script to avoid some issues observed with container restart 
#ADD run-apache.sh /run-apache.sh
#RUN chmod -v +x /run-apache.sh

#CMD ["/run-apache.sh"]
ENTRYPOINT [ "/usr/sbin/httpd" ]
CMD [ "-D", "FOREGROUND" ]
