//
//  NSString+Coded.m
//  StringEncryption
//
//  Created by 袁志浦 on 2016/10/8.
//  Copyright © 2016年 袁志浦. All rights reserved.
//

#import "NSString+Coded.h"

@implementation NSString (MD5)

- (NSString *)MD5Hash{
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (CC_LONG) [self length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
    
}

@end


@implementation NSString (DES)

///加密
- (NSString *)encryptUseDESWithkey:(NSString *)key{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {//成功
        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        plainText = [GTMBase64 stringByEncodingData:dataTemp];
    }else{
        NSLog(@"DES加密失败");
    }
    return plainText;
}

///DES解密
- (NSString*)decryptUseDESWithkey:(NSString*)key{
    // 利用 GTMBase64 解碼 Base64 字串
    NSData* cipherData = [GTMBase64 decodeString:self];
    
    const void *dataIn;
    size_t dataInLength;
    
    dataInLength = [cipherData length];
    dataIn = [cipherData bytes];
    
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    //CCCrypt函数 解密
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,//  解密
                                          kCCAlgorithmDES,//  解密根据哪个标准（des，3des，aes。。。。）
                                          kCCOptionPKCS7Padding |kCCOptionECBMode,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                                          [key UTF8String],  //密钥    加密和解密的密钥必须一致
                                          kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                                          nil, //  可选的初始矢量
                                          dataIn, // 数据的存储单元
                                          dataInLength,// 数据的大小
                                          (void *)dataOut,// 用于返回数据
                                          dataOutAvailable,
                                          &dataOutMoved);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:(void *)dataOut length:(NSUInteger)dataOutMoved];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}
@end
