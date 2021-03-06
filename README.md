# 介绍
基于CentOS 7的Nginx 容器。

### 目录结构约定：
约定目的: 与docker无关,自用,对于虚拟主机web-name而言所有文件都在它自己目录里了。

|  目录                         |             用途                                     |
|-------------------------------|------------------------------------------------------|
|/home/nginx/conf/              |Nginx的主配置包含nginx.conf/fastcgi.conf/mime.types等 |
|/home/nginx/conf/vhost.d/      |Nginx的子配置包含server{}段的配置,但建议都是硬link文件|
|/home/nginx/apps/web-name/conf/|当前虚拟主机的子配置,上方vhost.d里硬link的源          |
|/home/nginx/apps/web-name/html/|html/php/png/css/js等文件,并作为当前虚拟主机的根目录  |
|/home/nginx/apps/web-name/logs/|access和error日志等                                   |

## 创建镜像：
1. 获取：
<pre>
cd ~
git clone https://github.com/djluo/docker-nginx.git
</pre>
2. 构建镜像：
<pre>
cd ~/docker-nginx
sudo docker build -t nginx   .
sudo docker build -t nginx:3 .
</pre>

## 使用：
1. 建立主目录：
<pre>
sudo mkdir -p /home/nginx/{conf/vhost.d,html}
</pre>
2. 建立虚拟主机目录（已www.example.com为例）：
<pre>
sudo mkdir -p /home/nginx/apps/www.example.com/{conf,html,logs}
</pre>
3. 创建Nginx主配置：
<pre>
cd ~/docker-nginx/
sudo cp -a ./conf/ /home/nginx/
</pre>
4. 创建虚拟主机子配置：
<pre>
cat<<\EOF >> /home/nginx/apps/www.example.com/conf/nginx.conf
server {
  listen       80;
  server_name  localhost;

  root       /home/nginx/apps/www.example.com/html;
  access_log /home/nginx/apps/www.example.com/logs/access.log;

  location = /favicon.ico {
      log_not_found off;
      access_log off;
  }

  location / {
      autoindex on;
  }
}
# vim:set et ts=2 sw=2: #
EOF
</pre>
5. 创建硬链接（上方的约定）：
<pre>
cd /home/nginx/conf/vhost.d/
sudo ln -v /home/nginx/apps/www.example.com/conf/nginx.conf ./www.example.com.conf
</pre>
6. 启动容器：
<pre>
CID=$(sudo docker run -d -p 80:80   \
       --name www.example.com \
       -v /home/nginx/conf/:/etc/nginx/       \
       -v /home/nginx/apps/:/home/nginx/apps/ \
       nginx /usr/sbin/nginx)
</pre>
7. 测试：
<pre>
cd /home/nginx/apps/www.example.com/html
echo 'hello world!!!' | sudo tee -a index.html
curl -x 127.0.0.1:80 http://www.example.com/index.html
</pre>

## 日常维护：

| 操作       |命令                           |
|------------|-------------------------------|
|日志切割    |`sudo docker kill -s USR1 $CID`|
|重新导入配置|`sudo docker kill -s HUP $CID` |
|停止服务    |`sudo docker stop  $CID`       |
|开启服务    |`sudo docker start $CID`       |
