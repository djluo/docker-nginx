# Nginx
#
# Version 2

FROM centos
MAINTAINER djluo <dj.luo@baoyugame.com>

RUN rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum -y install nginx; yum clean all

ADD ./conf/ /etc/nginx/
RUN rm -f /etc/nginx/conf.d/{default.conf,example_ssl.conf}
#RUN rm -f /etc/nginx/{koi-utf,koi-win,scgi_params,uwsgi_params,win-utf}

EXPOSE 80

WORKDIR /etc/nginx
VOLUME ["/data/logs"]

CMD [ "/usr/sbin/nginx" ]
