//
//  XBBarAccount.m
//  Hippo
//
//  Created by jock on 16/6/30.
//  Copyright © 2016年 jock. All rights reserved.
//

#import "XBAccount.h"

@implementation XBAccount
+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",@"Description":@"description"};
}

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


/**
 *  从文件中解析对象的时候调
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.account = [decoder decodeObjectForKey:@"account"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.verCode = [decoder decodeObjectForKey:@"verCode"];
        self.userState = [decoder decodeObjectForKey:@"userState"];
        self.expireTime=[decoder decodeObjectForKey:@"expireTime"];
        self.ID = [decoder decodeObjectForKey:@"ID"];
        self.headpic = [decoder decodeObjectForKey:@"headpic"];
        self.nickname = [decoder decodeObjectForKey:@"nickname"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.integral = [decoder decodeObjectForKey:@"integral"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
        self.pushType = [decoder decodeObjectForKey:@"pushType"];
        self.pushtoken = [decoder decodeObjectForKey:@"pushtoken"];
        self.registerTime = [decoder decodeObjectForKey:@"registerTime"];
        self.mysign=[decoder decodeObjectForKey:@"mysign"];

    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    if (self.ID) {
        [encoder encodeObject:self.ID forKey:@"ID"];
    }
    if (self.account) {
        [encoder encodeObject:self.account forKey:@"account"];
    }
    if (self.token) {
        [encoder encodeObject:self.token forKey:@"token"];
    }
    if (self.verCode) {
        [encoder encodeObject:self.verCode forKey:@"verCode"];
    }
    if (self.userState) {
        [encoder encodeObject:self.userState forKey:@"userState"];
    }
    if (self.expireTime) {
        [encoder encodeObject:self.expireTime forKey:@"expireTime"];
    }
    if (self.headpic) {
        [encoder encodeObject:self.headpic forKey:@"headpic"];
    }
    if (self.nickname) {
        [encoder encodeObject:self.nickname forKey:@"nickname"];
    }
    if (self.phone) {
        [encoder encodeObject:self.phone forKey:@"phone"];
    }
    if (self.integral) {
        [encoder encodeObject:self.integral forKey:@"integral"];//积分
    }
    if (self.sex) {
        [encoder encodeObject:self.sex forKey:@"sex"];
    }
    if (self.pushType) {
        [encoder encodeObject:self.pushType forKey:@"pushType"];
    }
    if (self.pushtoken) {
        [encoder encodeObject:self.pushtoken forKey:@"pushtoken"];
    }
    if (self.registerTime) {
        [encoder encodeObject:self.registerTime forKey:@"provinceName"];
    }
    if (self.mysign) {
        [encoder encodeObject:self.mysign forKey:@"mysign"];
    }
}
@end
