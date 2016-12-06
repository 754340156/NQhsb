//
//  Html5FootViewModel.h
//  Operator
//
//  Created by 白小田 on 2016/10/26.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Html5FootResponse,Html5FootList;
@interface Html5FootViewModel : NSObject

@property (nonatomic, strong) Html5FootResponse *response;

@property (nonatomic, copy) NSString *code;

@end
@interface Html5FootResponse : NSObject

@property (nonatomic, assign) NSInteger startOfNextPage;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL hasPrevious;

@property (nonatomic, assign) NSInteger nextPage;

@property (nonatomic, assign) NSInteger previousPage;

@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, strong) NSArray<Html5FootList *> *list;

@property (nonatomic, assign) NSInteger startOfLastPage;

@property (nonatomic, assign) NSInteger startOfPreviousPage;

@property (nonatomic, assign) BOOL hasNext;

@property (nonatomic, assign) NSInteger pageSize;

@end

@interface Html5FootList : NSObject

@property (nonatomic, copy) NSString *dataId;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *dtCreat;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *timeLength;
@end

