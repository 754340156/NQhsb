//
//  CollectionViewCell.m
//  Operator
//
//  Created by hai on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "CollectionViewCell.h"
#import "HWCollectionModel.h"
@interface CollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameL;
@property (weak, nonatomic) IBOutlet UILabel *clickNumL;

@end


@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageV.layer.masksToBounds = YES;
    self.iconImageV.layer.cornerRadius  = self.iconImageV.width;
}
-(void)setModel:(HWCollectionModel *)model
{
    _model = model;
#warning 站位图没写
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:nil];
    self.titleLabel .text = model.title;
#warning   接口昵称没给
//    self.nikeNameL.text = model.nickname;
    self.clickNumL.text = [NSString stringWithFormat:@"%ld人浏览",(long)model.clickNum];
}

@end
