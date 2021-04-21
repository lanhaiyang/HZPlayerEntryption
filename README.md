# HZPlayerEntryption

### 视频加密Demo：
- 包含后端逻辑和客户端逻辑，客户端只做了iOS，没有做Android


### 打开终端

```
cd .../HZPlayerEntryptionServer
python2  manage.py runserver 0.0.0.0:8000
// 改了端口号要在项目同步修改
```

- 打开浏览器输入`http://127.0.0.1:8000/api/v1/files`

选择一个mp3或者mp4

![](https://github.com/lanhaiyang/HZPlayerEntryption/blob/main/README/1%402x.png)

- 点击`提交`等待

![](https://github.com/lanhaiyang/HZPlayerEntryption/blob/main/README/2.png)

- 复制链接

### 然后打开 TestPlayer

```
-(void)configeMp3;//用来测试音频
-(void)configeMp4;//用来测试视频
```

- 替换链接

![](https://github.com/lanhaiyang/HZPlayerEntryption/blob/main/README/3.png)

- ../key.key 解密秘钥 可以用在Server的views.py 里面修改

![](https://github.com/lanhaiyang/HZPlayerEntryption/blob/main/README/4.png)