# Nginx
#
# Version 3

FROM centos
MAINTAINER djluo <dj.luo@baoyugame.com>

RUN rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum -y install nginx; yum clean all

EXPOSE 80

VOLUME ["/etc/nginx"]

CMD [ "/usr/sbin/nginx" ]
