//
//  HZ_M3U8LoadManager.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/10/8.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HZ_M3U8LoadManager.h"
#import "HZ_M3U8LoadViewModel.h"

@interface HZ_M3U8LoadManager()

@property(nonatomic,strong) HZ_M3U8LoadViewModel *loadViewModel;

@end

@implementation HZ_M3U8LoadManager

#pragma mark - AVAssetResourceLoaderDelegate

///要求加载资源的代理方法
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader
shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    [_loadViewModel addLoadingWithRequest:loadingRequest];
    
    return YES;
}



///取消加载资源的代理方法
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader
didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest{
    
    [_loadViewModel removeLoadingRequest:loadingRequest];
}

/// 如果用户正在滑动进度条
- (void)isSlideProgress{
    
    
}

/// 通过url生成 AVURLAsset 对象
- (AVURLAsset *)getURLAssetObjectWithURL:(NSURL *)url withDecryptionKeyPassword:(NSString *)password{
    
    if (url == nil) {
        return nil;
    }
    if ([_delegate respondsToSelector:@selector(hz_requestTaskWithState:error:)]) {
        [_delegate hz_requestTaskWithState:HZ_RequestTaskLoading error:nil];
    }
    if (password.length != 0) {
        NSData *m3u8Data = [NSData dataWithContentsOfURL:url];
        NSString *m3u8Content = [[NSString alloc] initWithData:m3u8Data encoding:NSUTF8StringEncoding];
        if (m3u8Content.length == 0) {
            if ([_delegate respondsToSelector:@selector(hz_requestTaskWithState:error:)]) {
                [_delegate hz_requestTaskWithState:HZ_RequestTaskFailse error:nil];
            }
            return nil;
        }
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
        NSData *keyData = [NSData dataWithContentsOfURL:[NSURL URLWithString:keyURL]];
        NSString *key = [HZ_M3U8LoadViewModel decryptData:keyData key:password];
        key = [HZ_M3U8LoadViewModel hexStringFromString:key];
        self.loadViewModel.key = key;
    }
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:url options: nil];
    return urlAsset;
}

#pragma mark - 懒加载

-(HZ_M3U8LoadViewModel *)loadViewModel{
    
    if (_loadViewModel == nil) {
        _loadViewModel = [[HZ_M3U8LoadViewModel alloc] init];
    }
    return _loadViewModel;
}

@end
