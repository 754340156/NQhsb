//
//  HWOperationCell.m
//  Operator
//
//  Created by hai on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWOperationCell.h"
#import "HWOperationModel.h"
@interface HWOperationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameL;
@property (weak, nonatomic) IBOutlet UILabel *clickNumL;
@end

@implementation HWOperationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageV.layer.cornerRadius = 63 / 2;
    self.iconImageV.layer.masksToBounds = YES;
    _titleLabel.textColor = color_333333;
    _nikeNameL.textColor  = color_323232;
    _clickNumL.textColor  = color_666666;
    [self dealDeleteButton];
}

- (void)setModel:(HWOperationModel *)model
{
    _model = model;
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"ICON_T"]];
    self.titleLabel.text = model.title;
    self.nikeNameL.text = model.nickname;
    self.clickNumL.text = [NSString stringWithFormat:@"%ld人浏览",(long)model.clickNum];
}
- (void)dealDeleteButton{
    for (UIView *subView in self.subviews) {
        
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            
            subView.backgroundColor = [UIColor blueColor];
            
            for (UIButton *button in subView.subviews) {
                
                if ([button isKindOfClass:[UIButton class]]) {
                    
                    button.backgroundColor = KTabBarColor;
                    
                }
            }
        }
    }
}
@end
