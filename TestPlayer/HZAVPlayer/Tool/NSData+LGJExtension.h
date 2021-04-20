//
//  NSData+LGJExtension.h
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/10/4.
//  Copyright © 2020 何鹏. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (LGJExtension)


/**
 NSData转化成string

 @return 返回nil的解决方案
 */
-(NSString *)convertedToUtf8String;

@end

NS_ASSUME_NONNULL_END
