//
//  SalesjobCell.m
//  Operator
//
//  Created by 白小田 on 16/9/19.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "SalesjobCell.h"

@interface SalesjobCell ()
@property (weak, nonatomic) IBOutlet UIImageView *kBxtTitleImage;
@property (weak, nonatomic) IBOutlet UILabel *kBxtTitle;
@property (weak, nonatomic) IBOutlet UILabel *kBxtContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *kBxtUserCatCount;

@end

@implementation SalesjobCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.kBxtTitleImage.layer.masksToBounds = YES;
    self.kBxtTitleImage.layer.cornerRadius  = 25;
}
-(void)setList:(BigForumList *)list
{
    _list = list;
    [self.kBxtTitleImage sd_setImageWithURL:[NSURL URLWithString:list.cover] placeholderImage:[UIImage imageNamed:@"ICON_T"]];
    self.kBxtTitle .text = list.title;
    self.kBxtContentLabel.text = list.nickname;
    self.kBxtUserCatCount.text = [NSString stringWithFormat:@"%ld人浏览",(long)list.clickNum];
}
-(void)setSearchList:(MainSearchFinishList *)searchList
{
    _searchList = searchList;
    [self.kBxtTitleImage sd_setImageWithURL:[NSURL URLWithString:_searchList.cover] placeholderImage:[UIImage imageNamed:@"ICON_T"]];
    self.kBxtTitle .text = _searchList.title;
    self.kBxtContentLabel.text = _searchList.nickname;
    self.kBxtUserCatCount.text = [NSString stringWithFormat:@"%ld人浏览",(long)_searchList.clickNum];
}
@end
