//
//  MainSearchModels.h
//  Operator
//
//  Created by 白小田 on 16/10/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MainSearchResponse;
@interface MainSearchModels : NSObject

@property (nonatomic, strong) NSArray<MainSearchResponse *> *response;

@property (nonatomic, copy) NSString *code;

@end
@interface MainSearchResponse : NSObject

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, copy) NSString *dataId;

@end

