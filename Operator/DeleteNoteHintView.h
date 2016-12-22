//
//  DeleteNoteHintView.h
//  Operator
//
//  Created by zhaozhe on 16/12/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface DeleteNoteHintView : UIView

/**  点击按钮回调 */
@property(nonatomic,copy) void (^clickIsSureBlock)(BOOL isSure);
@end
