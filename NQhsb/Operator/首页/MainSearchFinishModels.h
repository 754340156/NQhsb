//
//  MainSearchFinishModels.h
//  Operator
//
//  Created by 白小田 on 16/10/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MainSearchFinishResponse,MainSearchFinishList;
@interface MainSearchFinishModels : NSObject

@property (nonatomic, strong) MainSearchFinishResponse *response;

@property (nonatomic, copy) NSString *code;

@end
@interface MainSearchFinishResponse : NSObject

@property (nonatomic, assign) NSInteger startOfNextPage;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL hasPrevious;

@property (nonatomic, assign) NSInteger nextPage;

@property (nonatomic, assign) NSInteger previousPage;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, strong) NSArray<MainSearchFinishList *> *list;

@property (nonatomic, assign) NSInteger startOfLastPage;

@property (nonatomic, assign) NSInteger startOfPreviousPage;

@property (nonatomic, assign) BOOL hasNext;

@property (nonatomic, assign) NSInteger pageSize;

@end

@interface MainSearchFinishList : NSObject

@property (nonatomic, copy) NSString *dataId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, assign) NSInteger clickNum;

@end

