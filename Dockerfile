FROM docker.xlands-inc.com/baoyu/debian
MAINTAINER djluo <dj.luo@baoyugame.com>

ADD ./sources.list /etc/apt/

RUN export http_proxy="http://172.17.42.1:8080/" \
    && export DEBIAN_FRONTEND=noninteractive     \
    && apt-key adv --keyserver pgp.mit.edu \
                   --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
    && apt-get update \
    && apt-get install -y nginx \
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
