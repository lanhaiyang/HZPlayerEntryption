#coding=utf8
# 导入DES模块
from Crypto.Cipher import DES
from django.shortcuts import render
from django.http import HttpResponse
from models import *
import sys
import json
from django.views.decorators.csrf import csrf_exempt
import hashlib
import random
import os
import uuid
import hashlib
import subprocess
import linecache
import base64


import binascii

reload(sys)


Key = 'x3Y8JJ6a&r16iehu'# m3u8 加密key
encKey = 'Pu!Wj3@V'# m3u8 加密key，在加密key


# 需要去生成一个DES对象
def pad(text):
     """
       # 加密函数，如果text不是8的倍数【加密文本text必须为8的倍数！】，那就补足为8的倍数
        :param text:
        :return:
     """
     while len(text) % 8 != 0:
        text += ' '
     return text

sys.setdefaultencoding('utf8')

def MD5(s):
    '''对字符串s进行md5加密，并返回'''
    m = hashlib.md5()
    m.update(s)
    return m.hexdigest()

def get_unique_str():
    # 得到一个uuid的字符串
    uuid_str = str(uuid.uuid4()).encode("utf-8")
    # 实例化md5
    md5 = hashlib.md5()
    # 进行加密
    md5.update(uuid_str)
    # 返回32位的十六进制数据
    return md5.hexdigest()

def test(request):
    return render(request,'index.html')

def hello(request):
    '''测试接口'''
    return HttpResponse("Hello, I am iHealth ' backend!")

def deletFile(path):
    print '**** remove *** ' + path
    if os.path.exists(path):  # 如果文件存在
        # 删除文件，可使用以下两种方法。
        os.remove(path)
        #os.unlink(path)
    else:
        print('no such file:%s'%my_file)  # 则返回文件不存在

def files(req):
    if req.method == 'GET':
        return render(req,'myFile.html')
    else:
        #name = req.POST.get('name')
        myfile = req.FILES.get('icon')
        md5Dir = get_unique_str();
        filename = myfile.name # 文件名
        
        soucesFileName = 'm3u8File'
        
        fileDir = settings.MEDIA_ROOT + '/' + soucesFileName + "/" + md5Dir; # 分类目录
        if not os.path.exists(fileDir):#  文件是否存在如果不存在就创建
            os.makedirs(fileDir)
            #        print '***'+filename
        # 文件路径
        filepath = os.path.join(fileDir,filename)
        f = open(filepath,'wb')
        for i in myfile.chunks():
            f.write(i)
        f.close()
        
        suffix = myfile.name.split('.')[-1];
        m3u8Dir = 'm3u8'
        m3u8Dir = fileDir + '/' + m3u8Dir;
        if not os.path.exists(m3u8Dir):#  文件是否存在如果不存在就创建
            os.makedirs(m3u8Dir)
        avDir = fileDir + '/' + filename
        m3u8File = ''
        command = ''
        if suffix == 'mp4':
            print 'mp4'
            
            command = 'ffmpeg -i ' + avDir + ' -c:v libx264 -hls_time 3 -hls_list_size 0 -c:a aac -strict -2 -f hls '+ m3u8Dir +'/video.m3u8'
            m3u8File = 'video.m3u8'
        elif suffix == 'mp3':
            print 'mp3'
            command = 'ffmpeg -i ' + avDir + ' -c:v libaac -hls_time 3 -hls_list_size 0 -c:a aac -strict -2 -f hls '+ m3u8Dir +'/music.m3u8'
            m3u8File = 'music.m3u8'
        
        try:
            retcode = subprocess.call(command, shell=True)
            if retcode == 0:
                print "successed------"
                deletFile(avDir);
            else:
                print "is failed--------"
        except Exception as e:
            print e
            
        # ts加密
        HexKey = toHex(Key)
        # 文件路径
        filepath = os.path.join(m3u8Dir,m3u8File)
        f = open(filepath,'r')
        count = 0
#        print f.readlines()

        # 这是密钥,此处需要将字符串转为字节
        key = encKey
        #EXT-X-KEY:METHOD=AES-128,URI="key.key"   #这个就是密钥
        # 创建一个DES实例
        iv = 16 * b'\0'
        des = DES.new(key,DES.MODE_ECB,iv)
        padded_text = pad(Key)# 加密内容
        encrypted_text = des.encrypt(padded_text)
        keyFile = m3u8Dir + '/key.key';
        print '****2 =>' + encrypted_text
        text_create(keyFile,encrypted_text)# 生成.key文件
        
        # 解密
        plain_text = des.decrypt(encrypted_text)
        print '****2 =>' + plain_text
        
        m3u8FileEnc = ''
        for line in f.readlines():
            
            line = line.replace('\n','')
            #EXTM3U
            if line.endswith('#EXTM3U'):
                m3u8FileEnc = m3u8FileEnc + line + '\n'
                m3u8FileEnc = m3u8FileEnc + '#EXT-X-KEY:METHOD=AES-128,URI="http://127.0.0.1:8000/static/'+ soucesFileName + '/' + md5Dir+'/m3u8/key.key"\n'
            elif line.endswith('.ts'):
                try:
                    dir = m3u8Dir + '/' + line
                    encString = 'video' +str(count) +'Enc.ts'
                    command = 'openssl enc -aes-128-cbc -in '+ dir +' -out ' +m3u8Dir + '/'+encString+' -e -K '+ HexKey + ' -iv 00000000000000000000000000000000 -nosalt'
                    print '=> ' + command;
                    count = count + 1;
                    retcode = subprocess.call(command, shell=True)
                    if retcode == 0:
                        print "successed------"
                        deletFile(dir);
                        m3u8FileEnc = m3u8FileEnc + encString  + '\n'
                    else:
                        print "is failed--------"
                except Exception as e:
                    print e
            else:
                m3u8FileEnc = m3u8FileEnc + line + '\n'
        text_create(m3u8Dir + '/' + m3u8File,m3u8FileEnc)# 生成加密后的m3u8

        
        return HttpResponse('上传成功 OK')
    


    
    
    
# 创建一个txt文件，文件名为mytxtfile,并向文件写入msg
def text_create(desktop_path, msg):
    file = open(desktop_path, 'w')
    file.write(msg)   #msg也就是下面的Hello world!
    
    

def toHex(s):
    lst = []
    for ch in s:
        hv = hex(ord(ch)).replace('0x', '')
        if len(hv) == 1:
            hv = '0'+hv
        lst.append(hv)
   
    return reduce(lambda x,y:x+y, lst)

def updateKey(req):
    return HttpResponse('上传成功 OK')


