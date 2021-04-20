//
//  HZ_PasswordViewModel.h
//  FlowerTown
//
//  Created by 何鹏 on 2019/1/3.
//  Copyright © 2019 HuaZhen. All rights reserved.
// ase加密

#import <Foundation/Foundation.h>

@interface HZ_PasswordViewModel : NSObject

/// 加密 ase128
+ (NSString *)hz_encryptStringWithString:(NSString *)string andKey:(NSString *)key;

/// 解密 ase128
+ (NSString *)hz_decryptStringWithString:(NSString *)string andKey:(NSString *)key;

@end
