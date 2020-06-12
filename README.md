# flask_docker
使用docker 简单部署一次flask


1. 服务器安装docker 环境配置好 拉去`ubuntu`镜像

2. 配置`Dockerfile`


**暂时没用`supervisor`**

```dockerfile

FROM ubuntu:test
# 作者名
LABEL maintainer="cyq"
# 防止构建出错
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONIOENCODING=utf-8

#两行命令，设定ubuntu的apt源为阿里源，加快下面下载所需依赖的速度。
#使用阿里源从python库中下载文件，所以使用pip.conf添加阿里源。2、3行是复制supervisor相关配置文件进image文件里，最后一行更新pip.
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
&& sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
&& apt-get clean \
&& apt-get update \
&& apt-get install -y python3-pip python3-dev nginx supervisor \
&& rm -rf /var/lib/apt/lists/*



ADD pip.conf /etc/pip.conf
#COPY supervisord.conf /etc/supervisord.conf
#COPY supervisor.conf /etc/supervisor.conf
RUN pip3 install --upgrade pip

#复制项目, 安装依赖 配置nginx
COPY . /app
WORKDIR /app
RUN  pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple  -r requirements.txt \
&& ln -s /app/nginx.conf /etc/nginx/conf.d \
&& rm -rf /etc/nginx/sites-enabled/default \
#&& rm -rf /etc/supervisor/supervisord.conf \
#&& sed -i 's/nodaemon=false/nodaemon=true/g'

# gunicorn 命令执行
CMD ["gunicorn","app:app","-c", "gunicorn.conf.py"]

```

3. 配置其他

4. `docker image bulid -t flask_docker .` 命令

5. 构建完成, 生成镜像

6. `docker run --name flask -d -p 8000:8000 flask_docker`
    1. `-d` 后台运行
    2. '-p' 8000:8000  服务监听端口:docker 任务监听端口
    
