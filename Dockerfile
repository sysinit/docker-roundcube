#
FROM ubuntu:14.04
MAINTAINER Frank Mueller "tmp@sysinit.de"

# increase serial to run everything from here again
ENV SERIAL 2015042401

# install updates
RUN DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -qq -y update; apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade

# install needed base packages
RUN apt-get install -y wget vim libapache2-mod-php5 php5-mcrypt php5 php-pear
RUN pear install mail_mime mail_mimedecode net_smtp net_idna2-beta auth_sasl net_sieve crypt_gpg

RUN a2enmod expires && a2enmod headers && a2enmod ssl

RUN  wget http://downloads.sourceforge.net/project/roundcubemail/roundcubemail/1.1.1/roundcubemail-1.1.1-complete.tar.gz -O - | tar xz -C /var/www --strip=1

ADD ../config.inc.php /var/www/config/

RUN sed -i -re '/^\s*DocumentRoot/s, /.*, /var/www,' \
    /etc/apache2/sites-available/000-default.conf \
    /etc/apache2/sites-available/default-ssl.conf
#    a2ensite default-ssl.conf

RUN rm -rf /var/www/installer

RUN . /etc/apache2/envvars && chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} /var/www/temp /var/www/logs

# ports
EXPOSE 80 443

ENTRYPOINT [ "/usr/sbin/apache2ctl", "-D", "FOREGROUND" ]
CMD [ "-k", "start" ]
