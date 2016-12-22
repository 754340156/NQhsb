//
//  NSString+Coded.h
//  StringEncryption
//
//  Created by 袁志浦 on 2016/10/8.
//  Copyright © 2016年 袁志浦. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>

#import <CommonCrypto/CommonCryptor.h>

#import "GTMBase64.h"

@interface NSString (MD5)

- (NSString *)MD5Hash;

@end

@interface NSString (DES)

///加密
- (NSString *)encryptUseDESWithkey:(NSString *)key;

///解密
- (NSString *)decryptUseDESWithkey:(NSString*)key;

@end
