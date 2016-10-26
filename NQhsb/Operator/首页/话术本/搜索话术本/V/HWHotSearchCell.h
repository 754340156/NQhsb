//
//  HWHotSearchCell.h
//  Operator
//
//  Created by hai on 16/10/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWHotSearchCellDelegate <NSObject>

- (void)HWHotSearchCellDelegate_ClickTitleText:(NSString *)titleText;

@end

@interface HWHotSearchCell : UICollectionViewCell
/**  <#注释#> */
@property (nonatomic,copy) NSString * titleText;
/**  代理 */
@property (nonatomic,weak) id <HWHotSearchCellDelegate>delegate;
+ (CGSize) getSizeWithText:(NSString*)text;
@end
