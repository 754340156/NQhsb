//
//  CustomHintView.h
//  lianxi
//
//  Created by hai on 16/10/24.
//  Copyright © 2016年 neiquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomHintViewDelegate <NSObject>
/**  点击确认按钮 */
- (void)CustomHintViewDelegate_clickSureBtn;
/**  点击取消按钮 */
- (void)CustomHintViewDelegate_clickCancelBtn;
@end


@interface CustomHintView : UIView
/**  titleText */
@property (nonatomic,copy) NSString * titleText;
/**  代理 */
@property (nonatomic,weak) id <CustomHintViewDelegate>delegate;
@end
