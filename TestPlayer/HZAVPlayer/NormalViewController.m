//
//  NormalViewController.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/8/31.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "NormalViewController.h"
#import <HZAVPlayer/HZ_AVPlayer.h>
#import <Masonry/Masonry.h>
#import "HZ_PasswordViewModel.h"
#import "NSData+LGJExtension.h"
#import <GCDWebServer/GCDWebServer.h>

#import <CommonCrypto/CommonCryptor.h>

@interface NormalViewController()<HZAVPlayerDelegate,HZAVPlayerRotateDelegate>

@property(nonatomic,strong) HZ_AVPlayer *avPlayer;
@property(nonatomic,strong) GCDWebServer *server;

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self layout];
    [self configeMp4];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [_server stop];
    //删除key
    NSString *keyPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/key.key"];;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDelete = [fileManager removeItemAtPath:keyPath error:nil];
    if (isDelete) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

-(void)configeMp3{
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *m3u8TopURL = @"http://127.0.0.1:8000/static/m3u8File/06c407bfa0ced27951fa5410d335f806/m3u8/";
            NSString *url =[NSString stringWithFormat:@"%@%@",m3u8TopURL,@"music.m3u8"];
            NSData *m3u8Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            NSString *m3u8Content = [[NSString alloc] initWithData:m3u8Data encoding:NSUTF8StringEncoding];
            if (m3u8Content.length == 0) {
                return ;
            }
            m3u8Content = [m3u8Content stringByReplacingOccurrencesOfString:@"video" withString:[NSString stringWithFormat:@"%@%@",m3u8TopURL,@"video"]];
            //        NSArray *array=[m3u8Content componentsSeparatedByString:@"URI=、"*\""];
            NSString *regularExpress = @"URI=\".*\"";
            NSString *keyURL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpress options:0 error:nil];
            if (regex != nil) {
                NSTextCheckingResult *firstMatch=[regex firstMatchInString:m3u8Content options:0 range:NSMakeRange(0, [m3u8Content length])];
                if (firstMatch) {
                    NSRange resultRange = [firstMatch rangeAtIndex:0];
                    keyURL=[m3u8Content substringWithRange:resultRange];
                    keyURL = [keyURL stringByReplacingOccurrencesOfString:@"URI=\"" withString:@""];
                    keyURL = [keyURL stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                }
            }
            //        if (array.count == 0) {
            //            return ;
            //        }
            //        NSString *keyURL = array[0];
            NSData *keyData = [NSData dataWithContentsOfURL:[NSURL URLWithString:keyURL]];
            NSString *key = [NormalViewController decryptData:keyData key:@"Pu!Wj3@V"];
            //        key = @"";
            //        key = [NormalViewController hexStringFromString:key];
            //        NSString *keyContent = keyData.convertedToUtf8String;
            //        NSString *key = [HZ_PasswordViewModel hz_decryptStringWithString:keyContent andKey:@"abcdefgh"];
            //        NSString *key = [NormalViewController decryptDes:keyContent key:@"abcdefgh"];
            //        NSString *str = securityResult.utf8String;
            //        str = [str stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            
            NSString *writePath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/"];
            
            self.server = [[GCDWebServer alloc] init];
            [self.server addGETHandlerForBasePath:@"/" directoryPath:writePath indexFilename:nil cacheAge:3600 allowRangeRequests:YES];
            [self.server startWithPort:8084 bonjourName:@"test"];
            NSString *keyPath = [NSString stringWithFormat:@"%@/key.key",writePath];
            NSError *error;
            [key writeToFile:keyPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"导出失败");
            }else {
                NSLog(@"导出成功");
            }
            
            
            m3u8Content = [m3u8Content stringByReplacingOccurrencesOfString:keyURL withString:[NSString stringWithFormat:@"http://localhost:%lu/key.key",(unsigned long)self.server.port]];
            
            NSString *encM3u8 = [NSString stringWithFormat:@"%@/enc.m3u8",writePath];
            [m3u8Content writeToFile:encM3u8 atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"导出失败");
            }else {
                
                NSLog(@"导出成功");
            };
            
            NSURL *path = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%lu/enc.m3u8",(unsigned long)self.server.port]];
            
            
    //        NSData *test = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%lu/enc.m3u8",self.server.port]]];
            
            [self.avPlayer playerWithUrl:path];
        });
}

-(void)configeMp4{
    
    //    NSString *url = @"http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4";
    //    NSString *url = @"https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8";
    
    //    NSString *writePath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/"];
    //
    //    GCDWebServer *server = [[GCDWebServer alloc] init];
    //    [server addGETHandlerForBasePath:@"/" directoryPath:writePath indexFilename:@"123.m3u8" cacheAge:3600 allowRangeRequests:YES];
    //    [server start];
    //
    //    NSURL *path = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%ld/123.m3u8",server.port]];
    //
    //    NSLog(@"encM3u8 = %@",writePath);
    ////    NSDate *data = [NSData dataWithContentsOfURL:path];
    //    [self.avPlayer playerWithUrl:path];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *m3u8TopURL = @"http://127.0.0.1:8000/static/m3u8File/aa94765a94c01b8d8285d02974670b0b/m3u8/";
        NSString *url =[NSString stringWithFormat:@"%@%@",m3u8TopURL,@"video.m3u8"];
        NSData *m3u8Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSString *m3u8Content = [[NSString alloc] initWithData:m3u8Data encoding:NSUTF8StringEncoding];
        if (m3u8Content.length == 0) {
            return ;
        }
        m3u8Content = [m3u8Content stringByReplacingOccurrencesOfString:@"video" withString:[NSString stringWithFormat:@"%@%@",m3u8TopURL,@"video"]];
        //        NSArray *array=[m3u8Content componentsSeparatedByString:@"URI=、"*\""];
        NSString *regularExpress = @"URI=\".*\"";
        NSString *keyURL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpress options:0 error:nil];
        if (regex != nil) {
            NSTextCheckingResult *firstMatch=[regex firstMatchInString:m3u8Content options:0 range:NSMakeRange(0, [m3u8Content length])];
            if (firstMatch) {
                NSRange resultRange = [firstMatch rangeAtIndex:0];
                keyURL=[m3u8Content substringWithRange:resultRange];
                keyURL = [keyURL stringByReplacingOccurrencesOfString:@"URI=\"" withString:@""];
                keyURL = [keyURL stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            }
        }
        //        if (array.count == 0) {
        //            return ;
        //        }
        //        NSString *keyURL = array[0];
        NSData *keyData = [NSData dataWithContentsOfURL:[NSURL URLWithString:keyURL]];
        NSString *key = [NormalViewController decryptData:keyData key:@"Pu!Wj3@V"];
        //        key = @"";
        //        key = [NormalViewController hexStringFromString:key];
        //        NSString *keyContent = keyData.convertedToUtf8String;
        //        NSString *key = [HZ_PasswordViewModel hz_decryptStringWithString:keyContent andKey:@"abcdefgh"];
        //        NSString *key = [NormalViewController decryptDes:keyContent key:@"abcdefgh"];
        //        NSString *str = securityResult.utf8String;
        //        str = [str stringByReplacingOccurrencesOfString:@"\0" withString:@""];
        
        NSString *writePath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/"];
        
        self.server = [[GCDWebServer alloc] init];
        [self.server addGETHandlerForBasePath:@"/" directoryPath:writePath indexFilename:nil cacheAge:3600 allowRangeRequests:YES];
        [self.server startWithPort:8084 bonjourName:@"test"];
        NSString *keyPath = [NSString stringWithFormat:@"%@/key.key",writePath];
        NSError *error;
        [key writeToFile:keyPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"导出失败");
        }else {
            NSLog(@"导出成功");
        }
        
        
        m3u8Content = [m3u8Content stringByReplacingOccurrencesOfString:keyURL withString:[NSString stringWithFormat:@"http://localhost:%lu/key.key",(unsigned long)self.server.port]];
        
        NSString *encM3u8 = [NSString stringWithFormat:@"%@/enc.m3u8",writePath];
        [m3u8Content writeToFile:encM3u8 atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"导出失败");
        }else {
            
            NSLog(@"导出成功");
        };
        
        NSURL *path = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%lu/enc.m3u8",(unsigned long)self.server.port]];
        
        
//        NSData *test = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%lu/enc.m3u8",self.server.port]]];
        
        [self.avPlayer playerWithUrl:path];
    });
}

+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
    
}


//解密
+(NSString *)decryptData:(NSData *)data key:(NSString*)key{
    
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionECBMode, keyPtr, kCCBlockSizeDES, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesEncrypted);
    if(cryptStatus == kCCSuccess){
        NSString *string = [[NSString alloc]initWithData:[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted] encoding:NSUTF8StringEncoding];
        NSLog(@"string = %@",string);
        return string;
    }
    free(buffer);
    return nil;
}

+(NSData *)hexStringToData:(NSString *)hexString{
    const char *chars = [hexString UTF8String];
    int i = 0;
    int len = (int)hexString.length;
    NSMutableData *data = [NSMutableData dataWithCapacity:len/2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i<len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}


-(void)layout{
    
    [self.view insertSubview:self.avPlayer atIndex:0];
    [self.avPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).equalTo(@64);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //横竖屏在哪个view上显示
    [self.avPlayer showCrosswise:self.avPlayer vertical:self.view];
    
}

#pragma mark - HPAVPlayerRotateDelegate

/**
 旋转的长宽
 
 @param rect 返回选择的长宽
 @param rotate 旋转的状态
 */
-(void)rotateWithChangeRect:(CGRect)rect rotate:(HZAVPlayerRotateStyle)rotate{
    [self.avPlayer playeUpdateWithPlayerLayer:rect];
}


/**
 点击播放页面
 */
-(void)tapActionView{
    
    [self.avPlayer playeTapActionView];
}


#pragma mark - HPAVPlayerRotateDelegate

/**
 视频加载状态
 
 @param loadState 加载状态
 @return 是否需要调用控件内部的事件 如:当在加载情况会显示加载控件 如果为NO就不会显示控件
 */
-(BOOL)loadWithState:(HZAVPlayerLoadeState)loadState{
    
    switch (loadState) {
        case HZPlayerLoadSuccess:{
            
            [self.avPlayer play];
        }
            break;
        case HZPlayerLoadEnd:{
        }
            break;
        case HZPlayerLoadFaile:{
            
        }
            break;
        default:
            break;
    }
    
    return YES;
}


-(HZ_AVPlayer *)avPlayer{
    if (_avPlayer == nil) {
        _avPlayer = [[HZ_AVPlayer alloc] init];
        _avPlayer.playerDelegate = self;
        _avPlayer.delegate = self;//这个可以选择不用调用
        
        _avPlayer.isCache = YES; // 开启缓存
        
        _avPlayer.fillState = HZAVPlayerResizeAspect;
        _avPlayer.rotateView.backgroundColor = [UIColor blackColor];
    }
    return _avPlayer;
}

@end
