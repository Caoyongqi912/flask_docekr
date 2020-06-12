bind = '0.0.0.0:8000'
worker_class = 'gevent'
workers = 3

# 设置进程文件目录
access_log_format = '%(t)s %(p)s %(h)s "%(r)s" %(s)s %(L)s %(b)s %(f)s" "%(a)s"'
accesslog = '../gunicorn_access.log'
errorlog = '../gunicorn_error.log'
# 设置日志记录水平
loglevel = 'debug'

