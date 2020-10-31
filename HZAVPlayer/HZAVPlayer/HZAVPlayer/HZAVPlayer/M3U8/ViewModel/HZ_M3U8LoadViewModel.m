//
//  HZ_M3U8LoadViewModel.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/10/8.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HZ_M3U8LoadViewModel.h"

@interface HZ_M3U8LoadViewModel()

@end

@implementation HZ_M3U8LoadViewModel


/// 有下载任务
-(void)addLoadingWithRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    
}

/// 下载完成时，把下载任务删除
- (void)removeLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    
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
//+(NSString *)decryptData:(NSData *)data key:(NSString*)key{
//    
//    char keyPtr[kCCKeySizeAES128+1];
//    bzero(keyPtr, sizeof(keyPtr));
//    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//    
//    NSUInteger dataLength = [data length];
//    
//    size_t bufferSize = dataLength + kCCBlockSizeAES128;
//    void *buffer = malloc(bufferSize);
//    
//    size_t numBytesEncrypted = 0;
//    
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionECBMode, keyPtr, kCCBlockSizeDES, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesEncrypted);
//    if(cryptStatus == kCCSuccess){
//        NSString *string = [[NSString alloc]initWithData:[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted] encoding:NSUTF8StringEncoding];
//        NSLog(@"string = %@",string);
//        return string;
//    }
//    free(buffer);
//    return nil;
//}

@end
