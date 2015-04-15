#
FROM ubuntu:14.04
MAINTAINER Frank Mueller "tmp@sysinit.de"

# increase serial to run everything from here again
ENV SERIAL 2015041501

# install updates
RUN DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -qq -y update; apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade

# install needed base packages
RUN apt-get install -y wget vim supervisor

# supvervisord config to start services
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# get owncloud repo key
RUN wget -O - http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_14.04/Release.key | apt-key add -

# add owncloud repo
RUN echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list
RUN apt-get update

# set mysql root password
RUN echo "mysql-server-5.5 mysql-server/root_password password root345" | debconf-set-selections
RUN echo "mysql-server-5.5 mysql-server/root_password_again password root345" | debconf-set-selections
RUN echo "mysql-server-5.5 mysql-server/root_password seen true" | debconf-set-selections
RUN echo "mysql-server-5.5 mysql-server/root_password_again seen true" | debconf-set-selections

# install owncloud and dependencies
RUN apt-get install -y owncloud

# ports
EXPOSE 80 443

# start apache or supervisord
#CMD ["/usr/sbin/apache2ctl", "-D",  "FOREGROUND"]
CMD ["/usr/bin/supervisord"]
