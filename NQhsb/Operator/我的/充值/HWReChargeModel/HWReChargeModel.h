//
//  HWReChargeModel.h
//  Operator
//
//  Created by NeiQuan on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface HWReChargeModel : BaseModel

@property(nonatomic,copy)NSString  *content;
@property(nonatomic,copy)NSString  *dataId;//goodsId
@property(nonatomic,copy)NSString  *dtCreat;
@property(nonatomic,copy)NSString  *onPic;
@property(nonatomic,copy)NSString  *price;
@property(nonatomic,copy)NSString  *title;

@end
