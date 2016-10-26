//
//  HWStudyPlanDetailModel.h
//  Operator
//
//  Created by hai on 16/10/19.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "BaseModel.h"
@class HWStudyPlanDetailData,HWCollectionModel;
@interface HWStudyPlanDetailModel : BaseModel
/**  <#注释#> */
@property (nonatomic,strong) HWStudyPlanDetailData * data;
/**  <#注释#> */
@property (nonatomic,strong) NSArray <HWCollectionModel*> *list;
@end
@interface HWStudyPlanDetailData : BaseModel
/**  <#注释#> */
@property (nonatomic,copy) NSString * account;
/**  内容 */
@property (nonatomic,copy) NSString * content;
/**  dataId */
@property (nonatomic,copy) NSString * dataId;
/**  创建时间 */
@property (nonatomic,copy) NSString * dtCreat;
/**  <#注释#> */
@property (nonatomic,copy) NSString * isShelves;
/**  备注 */
@property (nonatomic,copy) NSString * remark;
/**  标题 */
@property (nonatomic,copy) NSString * title;
@end
