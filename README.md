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



### 然后打开 TestPlayer

```
-(void)configeMp3;//用来测试音频
-(void)configeMp4;//用来测试视频
```

