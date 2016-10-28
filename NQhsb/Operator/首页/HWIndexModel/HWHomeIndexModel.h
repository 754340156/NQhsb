//
//  HWHomeIndexModel.h
//  Operator
//
//  Created by NeiQuan on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "BaseModel.h"

@interface HWHomeIndexModel : BaseModel

@property(nonatomic,copy)NSString  *cover;
@property(nonatomic,copy)NSString  *title;
@property(nonatomic,copy)NSString  *type;
@property(nonatomic,copy)NSString  *nickname;
@property(nonatomic,copy)NSString  *dataId;
@property(nonatomic,copy)NSString  *clickNum;//播放数量


@end

//轮播图model
@interface HWHomeIndexBannerModel : BaseModel

@property(nonatomic,copy)NSString  *title;
@property(nonatomic,copy)NSString  *dtCreat;
@property(nonatomic,copy)NSString  *bannerPic;
@property(nonatomic,copy)NSString  *dataId;

@end
