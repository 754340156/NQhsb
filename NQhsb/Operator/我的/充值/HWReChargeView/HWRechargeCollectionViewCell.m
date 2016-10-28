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
    
    __weak IBOutlet UIButton *_openButton;
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
    _openButton.layer.shadowRadius=3;
    _openButton.layer.shadowColor=KTabBarColor.CGColor;
    _openButton.layer.masksToBounds=YES;

}
#pragma mark --set方法
-(void)setChargemodel:(HWReChargeModel *)chargemodel{
    
    _chargemodel=chargemodel;
    [backImage sd_setImageWithURL:[NSURL URLWithString:chargemodel.onPic] placeholderImage:[UIImage imageNamed:@"BJ_BANNER"]];
    
    _priceText.text=[NSString stringWithFormat:@"￥%@",chargemodel.price];
    dateTextLable.text=[NSString stringWithFormat:@"%@天套餐",chargemodel.dtCreat];
    _titleText.text=chargemodel.title;
}
@end
