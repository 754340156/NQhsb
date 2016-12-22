//
//  HWJobLogDetailModel.h
//  Operator
//
//  Created by hai on 16/10/26.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "BaseModel.h"

@interface HWJobLogDetailModel : BaseModel
/**  创建时间 */
@property (nonatomic,copy) NSString * dtCreat;
/**  详情id */
@property (nonatomic,copy) NSString * dataId;
/**  title */
@property (nonatomic,copy) NSString * title;
/**  标注 */
@property (nonatomic,copy) NSString * remark;
/**  <#注释#> */
@property (nonatomic,copy) NSString * content1;
/**  <#注释#> */
@property (nonatomic,copy) NSString * content2;
/**  <#注释#> */
@property (nonatomic,copy) NSString * content3;
/**  <#注释#> */
@property (nonatomic,copy) NSString * content4;
/**  <#注释#> */
@property (nonatomic,copy) NSString * content5;
/**  <#注释#> */
@property (nonatomic,copy) NSString * content6;

@property (nonatomic,copy) NSString * content7;

@property (nonatomic,copy) NSString * content8;

@property (nonatomic,copy) NSString * content9;
/**  时间 */
@property (nonatomic,copy) NSString * wltime;
@end
