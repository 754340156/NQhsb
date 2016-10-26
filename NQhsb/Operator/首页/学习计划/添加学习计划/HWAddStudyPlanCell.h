//
//  HWAddStudyPlanCell.h
//  Operator
//
//  Created by hai on 16/10/19.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWCollectionModel,HWAddStudyPlanCell;
@protocol HWAddStudyPlanCellDelegate <NSObject>
/**  点击按钮加入或移除 */
- (void)HWAddStudyPlanCellDelegate_addStudyPlanOrRemoveWithBtn:(UIButton *)sender Model:(HWCollectionModel *)model Cell:(HWAddStudyPlanCell *)cell;
@end

@interface HWAddStudyPlanCell : UITableViewCell
@property (nonatomic, strong) HWCollectionModel *model;
/**  代理 */
@property (nonatomic,weak) id <HWAddStudyPlanCellDelegate>delegate;
@end
