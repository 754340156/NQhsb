//
//  HWRechargeCollectionViewCell.m
//  Operator
//
//  Created by NeiQuan on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWRechargeCollectionViewCell.h"
#import "HWReChargeModel.h"
@interface HWRechargeCollectionViewCell ()
{
   
    __weak IBOutlet UIImageView *backImage;
    
    __weak IBOutlet UILabel *_openLabel;
    __weak IBOutlet UILabel *_titleText;
    
    __weak IBOutlet UILabel *dateTextLable;
    __weak IBOutlet UILabel *_priceText;
}

@end

@implementation HWRechargeCollectionViewCell
-(void)awakeFromNib{
    
    [super awakeFromNib];
    backImage.layer.cornerRadius=3;
    backImage.layer.masksToBounds=YES;
    backImage.layer.shadowRadius=3;
    backImage.layer.shadowColor=[UIColor blackColor].CGColor;
    _openLabel.font = FontOfSize(13);
    _openLabel.layer.masksToBounds=YES;
    _openLabel.layer.cornerRadius = 5;
    _openLabel.layer.borderWidth = 1;
    _openLabel.layer.borderColor = KTabBarColor.CGColor;
    _openLabel.textColor = KTabBarColor;

}
#pragma mark --set方法
-(void)setChargemodel:(HWReChargeModel *)chargemodel{
    
    _chargemodel=chargemodel;
    [backImage sd_setImageWithURL:[NSURL URLWithString:chargemodel.onPic] placeholderImage:[UIImage imageNamed:@"BJ_BANNER"]];
    
    _priceText.text=[NSString stringWithFormat:@"￥%@",chargemodel.price];
    dateTextLable.text= chargemodel.title;
    _titleText.text=chargemodel.content;
}
@end
