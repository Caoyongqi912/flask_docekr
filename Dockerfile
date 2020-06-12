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
&& apt-get install -y python3-pip python3-dev nginx  \
&& rm -rf /var/lib/apt/lists/*



ADD pip.conf /etc/pip.conf
RUN pip3 install --upgrade pip

COPY . /app
WORKDIR /app
RUN  pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple  -r requirements.txt \
&& ln -s /app/nginx.conf /etc/nginx/conf.d \
&& rm -rf /etc/nginx/sites-enabled/default \

CMD ["gunicorn","app:app","-c", "gunicorn.conf.py"]
