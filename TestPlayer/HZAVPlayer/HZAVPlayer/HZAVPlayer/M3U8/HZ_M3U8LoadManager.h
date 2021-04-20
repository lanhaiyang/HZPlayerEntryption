//
//  HZ_M3U8LoadManager.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/10/8.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAssetResourceLoader.h>
#import <AVKit/AVKit.h>
#import "HZ_CacheVideoConfigeBase.h"

@protocol HZ_CacheLoadManagerDelegate  <NSObject>

 @optional

/// 任务下载的状态
-(void)hz_requestTaskWithState:(HZ_RequestTaskState)state error:(NSError *_Nullable)error;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HZ_M3U8LoadManager : NSObject<AVAssetResourceLoaderDelegate>

/// 监听任务下载的状态
@property(nonatomic,weak) id<HZ_CacheLoadManagerDelegate> delegate;

/// 如果用户正在滑动进度条
- (void)isSlideProgress;

/// 通过url生成 AVURLAsset 对象
- (AVURLAsset *)getURLAssetObjectWithURL:(NSURL *)url withDecryptionKeyPassword:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
