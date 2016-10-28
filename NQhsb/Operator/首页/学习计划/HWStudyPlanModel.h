//
//  HWStudyPlanModel.h
//  Operator
//
//  Created by hai on 16/10/19.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "BaseModel.h"

@interface HWStudyPlanModel : BaseModel
/**  title */
@property (nonatomic,copy) NSString * title;
/**  详情Id */
@property (nonatomic,copy) NSString * dataId;
/**  创建时间 */
@property (nonatomic,copy) NSString * dtCreat;
@end
