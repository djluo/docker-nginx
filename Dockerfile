FROM docker.xlands-inc.com/baoyu/debian:8
MAINTAINER djluo <dj.luo@baoyugame.com>

RUN export http_proxy="http://172.17.42.1:8080/" \
    && export DEBIAN_FRONTEND=noninteractive     \
    && apt-get update \
    && apt-get install -y nginx-light \
    && apt-get clean    \
    && unset http_proxy \
    && unset DEBIAN_FRONTEND   \
    && mkdir -p /var/log/nginx \
    && rm -rf /etc/nginx/*     \
    && rm -rf usr/share/locale \
    && rm -rf usr/share/man    \
    && rm -rf usr/share/doc    \
    && rm -rf usr/share/info   \
    && find var/lib/apt -type f -exec rm -fv {} \;

ADD ./conf/              /etc/nginx/
ADD ./entrypoint.pl      /entrypoint.pl

ENTRYPOINT ["/entrypoint.pl"]
CMD        ["/usr/sbin/nginx"]
