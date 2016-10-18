//
//  TitleModels.h
//  Operator
//
//  Created by 白小田 on 16/9/23.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <Foundation/Foundation.h>
@class titleResponse,titleNodes,titleTwoNodes,titleThreeNodes;
@interface TitleModels : NSObject

@property (nonatomic, strong) titleResponse *response;

@property (nonatomic, copy) NSString *code;

@end

@interface titleResponse : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *cname;

@property (nonatomic, strong) NSArray<titleNodes *> *nodes;

@end

@interface titleNodes : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *cname;

@property (nonatomic, strong) NSArray<titleTwoNodes *> *nodes;

@end

@interface titleTwoNodes : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *cname;

@property (nonatomic, strong) NSArray<titleThreeNodes *> *nodes;

@end

@interface titleThreeNodes : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *cname;

@property (nonatomic, strong) NSArray *nodes;

@end

