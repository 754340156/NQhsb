//
//  HWJobLogModel.h
//  Operator
//
//  Created by hai on 16/10/19.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "BaseModel.h"

@interface HWJobLogModel : BaseModel
/**  创建时间 */
@property (nonatomic,copy) NSString * dtCreat;
/**  title */
@property (nonatomic,copy) NSString * title;
/**  dataID */
@property (nonatomic,copy) NSString * dataId;
@end
