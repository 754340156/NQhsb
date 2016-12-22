//
//  DetailCell.h
//  Operator
//
//  Created by 白小田 on 2016/10/26.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Html5FootViewModel.h"
@interface DetailCell : UITableViewCell
kBxtPropertyStrong UIView   *kBxtHeadView;
kBxtPropertyStrong UILabel  *kBxtTimeLabel;
kBxtPropertyStrong UILabel  *audioLb;
kBxtPropertyStrong UIButton *kBxtDelegateButton;
kBxtPropertyStrong UIView   *kBxtLeftView;
kBxtPropertyStrong UILabel  *kBxtContentLabel;
kBxtPropertyStrong UIButton *kBxtAudioButton;
kBxtPropertyStrong Html5FootList *listModel;
kBxtPropertyAssign NSInteger  cellheight;

@end
