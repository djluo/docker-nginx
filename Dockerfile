# Nginx
#
# Version 3

FROM centos
MAINTAINER djluo <dj.luo@baoyugame.com>

RUN rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum -y install nginx; yum clean all

EXPOSE 80

VOLUME ["/home/nginx/conf", "/home/nginx/vhost"]

RUN rm -rfv /etc/nginx && ln -sv /home/nginx/conf /etc/nginx

WORKDIR /home/nginx

CMD [ "/usr/sbin/nginx" ]
