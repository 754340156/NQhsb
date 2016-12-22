//
//  HWAddStudyPlanCell.m
//  Operator
//
//  Created by hai on 16/10/19.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWAddStudyPlanCell.h"
#import "HWCollectionModel.h"
@interface HWAddStudyPlanCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameL;
@property (weak, nonatomic) IBOutlet UILabel *clickNumL;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end


@implementation HWAddStudyPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageV.layer.cornerRadius = 63 / 2;
    self.iconImageV.layer.masksToBounds = YES;
    self.addBtn.layer.borderColor = KTabBarColor.CGColor;
    self.addBtn.layer.borderWidth = 0.5f;
    self.addBtn.layer.cornerRadius = 3;
    self.addBtn.layer.masksToBounds = YES;
}

- (IBAction)addAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.model.isAdd = YES;
    }else
    {
        self.model.isAdd = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(HWAddStudyPlanCellDelegate_addStudyPlanOrRemoveWithBtn:Model:Cell:)]) {
        [self.delegate HWAddStudyPlanCellDelegate_addStudyPlanOrRemoveWithBtn:sender Model:self.model Cell:self];
    }
    
}
-(void)setModel:(HWCollectionModel *)model
{
    _model = model;
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"ICON_T"]];
    self.titleLabel .text = model.title;
    self.nikeNameL.text = model.nickname;
    self.clickNumL.text = [NSString stringWithFormat:@"%ld人浏览",(long)model.clickNum];
    self.addBtn.selected = model.isAdd;
}

@end
