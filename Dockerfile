#
FROM ubuntu:14.04
MAINTAINER Frank Mueller "tmp@sysinit.de"

# increase serial to run everything from here again
ENV SERIAL 2015042301

# install updates
RUN DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -qq -y update; apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade

# install needed base packages
RUN apt-get install -y wget vim

RUN wget http://downloads.sourceforge.net/project/roundcubemail/roundcubemail/1.1.1/roundcubemail-1.1.1-complete.tar.gz

# ports
EXPOSE 80 443

# start apache or supervisord
CMD ["/usr/sbin/apache2ctl", "-D",  "FOREGROUND"]
