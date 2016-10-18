//
//  HWOperationModel.h
//  Operator
//
//  Created by hai on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "BaseModel.h"

@interface HWOperationModel : BaseModel
/**  图片 */
@property (nonatomic,copy) NSString * cover;
/**  title */
@property (nonatomic,copy) NSString * title;
/**  作者昵称 */
@property (nonatomic,copy) NSString * nickname;
/**  dataID */
@property (nonatomic,copy) NSString * dataId;
/**  点击量 */
@property (nonatomic,assign) NSInteger clickNum;
@end
