//
//  HWEditPicCell.h
//  Operator
//
//  Created by hai on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWEditPicCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;
@end
