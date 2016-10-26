//
//  HWCollectionModel.h
//  Operator
//
//  Created by hai on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "BaseModel.h"


@interface HWCollectionModel : BaseModel

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *collId;

@property (nonatomic, copy) NSString *dataId;

@property (nonatomic, copy) NSString *dtCreat;

@property (nonatomic, assign) NSInteger clickNum;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *nickname;
/**  收藏的type */
@property (nonatomic,copy) NSString * type;
#pragma mark - 学习计划中用到的属性
/**  是否加入 */
@property (nonatomic,assign) BOOL isAdd;
@end

