//
//  BigForumModels.h
//  Operator
//
//  Created by 白小田 on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BigForumResponse,BigForumList;
@interface BigForumModels : NSObject

@property (nonatomic, strong) BigForumResponse *response;

@property (nonatomic, copy) NSString *code;

@end
@interface BigForumResponse : NSObject

@property (nonatomic, assign) NSInteger startOfNextPage;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL hasPrevious;

@property (nonatomic, assign) NSInteger nextPage;

@property (nonatomic, assign) NSInteger previousPage;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, strong) NSArray<BigForumList *> *list;

@property (nonatomic, assign) NSInteger startOfLastPage;

@property (nonatomic, assign) NSInteger startOfPreviousPage;

@property (nonatomic, assign) BOOL hasNext;

@property (nonatomic, assign) NSInteger pageSize;

@end

@interface BigForumList : NSObject

@property (nonatomic, copy) NSString *dataId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, assign) NSInteger clickNum;

@end

