//
//  HWHotSearchCell.m
//  Operator
//
//  Created by hai on 16/10/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWHotSearchCell.h"

@interface HWHotSearchCell ()
@property (weak, nonatomic) IBOutlet UIButton *hotSeaBtn;

@end


@implementation HWHotSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.hotSeaBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.hotSeaBtn.layer.borderWidth = 0.5;
    self.hotSeaBtn.layer.masksToBounds = YES;
    self.hotSeaBtn.layer.cornerRadius = 5;
}
- (IBAction)hotSeaAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HWHotSearchCellDelegate_ClickTitleText:)]) {
        [self.delegate HWHotSearchCellDelegate_ClickTitleText:self.titleText];
    }
}
- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    [self.hotSeaBtn setTitle:titleText forState:UIControlStateNormal];
    [self.hotSeaBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}
+ (CGSize) getSizeWithText:(NSString*)text
{
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options: NSStringDrawingUsesLineFragmentOrigin   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:style} context:nil].size;
    return CGSizeMake(size.width+20, 20);
}
@end
