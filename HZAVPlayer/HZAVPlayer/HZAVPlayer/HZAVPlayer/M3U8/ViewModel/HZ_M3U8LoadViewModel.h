//
//  HZ_M3U8LoadViewModel.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/10/8.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZ_M3U8LoadViewModel : NSObject


/// 有下载任务
-(void)addLoadingWithRequest:(AVAssetResourceLoadingRequest *)loadingRequest;

/// 下载完成时，把下载任务删除
- (void)removeLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest;

+ (NSString *)hexStringFromString:(NSString *)string;

//解密
+(NSString *)decryptData:(NSData *)data key:(NSString*)key;

@property(nonatomic,strong) NSString *key;

@end

NS_ASSUME_NONNULL_END
