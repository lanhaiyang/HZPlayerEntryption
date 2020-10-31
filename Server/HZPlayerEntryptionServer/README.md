## iHealth-site
iHealth 项目的后台程序

### 依赖
* Django==1.8.17
* pymongo==3.4.0
* uWSGI==2.0.15

### 启动项目
1. 本地启动（windows）：
```
python manage.py runserver 0.0.0.0:8000
```

2. 打开浏览器访问 **http://127.0.0.1:8000/**  
  出现 **Hello, I am iHealth ' backend!** 表示启动成功

3. 测试其它接口  
获取文章列表：http://127.0.0.1:8000/api/v1/articlelist  
获取文章详情：http://127.0.0.1:8000/api/v1/articledetail?id=59eefad4e6c80c707840adc2
