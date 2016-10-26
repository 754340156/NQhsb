//
//  HWMusicSelectedCell.m
//  Operator
//
//  Created by NeiQuan on 16/10/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicSelectedCell.h"

@implementation HWMusicSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        _rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-28, (self.height-20)*0.5, 20, 20)];
        
        _moduleTable=[[UILabel alloc] initWithFrame:CGRectMake(0,  (self.height-21)*0.5, WIDTH-50, 21)];
        _moduleTable.textAlignment=NSTextAlignmentRight;
        _moduleTable.textColor=[UIColor grayColor];
        _moduleTable.font=[UIFont systemFontOfSize:10];
        [self.contentView addSubview:_moduleTable];//添加子类视图
        [self.contentView addSubview:_rightImageView];//添加子类视图
    }
    
    return self;
}

@end
