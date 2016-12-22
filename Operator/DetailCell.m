//
//  DetailCell.m
//  Operator
//
//  Created by 白小田 on 2016/10/26.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "DetailCell.h"


@implementation DetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = color_f5f5f5;
        [self createUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
-(void)createUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    _kBxtHeadView = [[UIView alloc] init];
//    _kBxtHeadView.frame = CGRectMake(0, 0, WIDTH, 2);
//    _kBxtHeadView.backgroundColor = [UIColor colorWithWhite:0.89 alpha:1.0];
//    [self addSubview:_kBxtHeadView];
    
    _kBxtLeftView = [[UIView alloc] init];
    _kBxtLeftView.backgroundColor = KTabBarColor;
    [self addSubview:_kBxtLeftView];
    
    _kBxtTimeLabel = [[UILabel alloc] init];
    _kBxtTimeLabel.frame = CGRectMake(20, 10, WIDTH/3, 15);
    _kBxtTimeLabel.text = @"2016-10-27";
    _kBxtTimeLabel.font = FontOfSize(12);
    [self addSubview:_kBxtTimeLabel];
    
    _kBxtDelegateButton = [[UIButton alloc] init];
    _kBxtDelegateButton.frame = CGRectMake(_kBxtTimeLabel.right, _kBxtTimeLabel.top, 40, 15);
    [_kBxtDelegateButton setTitle:@"删除" forState:UIControlStateNormal];
    _kBxtDelegateButton.titleLabel.font = FontOfSize(12);
    [_kBxtDelegateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_kBxtDelegateButton];
    
    _kBxtContentLabel = [[UILabel alloc] init];
    _kBxtContentLabel.hidden = YES;
    _kBxtContentLabel.textColor = [UIColor blueColor];
    [self addSubview:_kBxtContentLabel];
    
    _kBxtAudioButton = [[UIButton alloc] init];
    [_kBxtAudioButton setFrame:CGRectMake(_kBxtTimeLabel.left, _kBxtTimeLabel.bottom+10, WIDTH-_kBxtLeftView.right-WIDTH/3, 40)];
    [_kBxtAudioButton setBackgroundColor:color_e5e5e5];
    _kBxtAudioButton.layer.masksToBounds = YES;
    _kBxtAudioButton.layer.cornerRadius  = 5;
    [_kBxtAudioButton setHidden:YES];
    [self addSubview:_kBxtAudioButton];
    
    UIImageView *audioImg = [[UIImageView alloc] init];
    audioImg.frame = CGRectMake(10, 0, 30, 40);
    audioImg.image = [UIImage imageNamed:@"ICON_Voice"];
    [_kBxtAudioButton addSubview:audioImg];
    
    _audioLb = [[UILabel alloc] init];
    _audioLb.frame = CGRectMake(50, 0, 50, 40);
    _audioLb.font = FontOfSize(12);
    [_kBxtAudioButton addSubview:_audioLb];//timeLength
    
    _kBxtTimeLabel.textColor = color_666666;
    _kBxtDelegateButton.titleLabel.textColor = color_666666;
    _kBxtContentLabel.textColor = color_666666;
    _audioLb.textColor = color_666666;
}
-(void)setListModel:(Html5FootList *)listModel
{
    _kBxtTimeLabel.text = listModel.dtCreat;
    
    if ([listModel.type isEqualToString:@"1"]) {
        [_kBxtContentLabel setHidden:NO];
        //2.将UILabel设置为自动换行
        [_kBxtContentLabel setNumberOfLines:0];
        
//        //4.获取所要使用的字体实例
//        UIFont *font = [UIFont fontWithName:@"Arial" size:14];
        _kBxtContentLabel.font = FontOfSize(12);
        //5.UILabel字符显示的最大大小
        CGSize size = CGSizeMake(WIDTH-40,2000);
        
        //6.计算UILabel字符显示的实际大小
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:listModel.content];
        _kBxtContentLabel.attributedText = attrStr;
        NSRange range = NSMakeRange(0, attrStr.length);
        NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];   // 获取该段
        CGSize labelsize = [listModel.content boundingRectWithSize:size
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     attributes:dic
                                                        context:nil].size;
        _kBxtContentLabel.frame = CGRectMake(20, 25, WIDTH-40, labelsize.height+20);
        _kBxtLeftView.frame = CGRectMake(10, 25, 1, labelsize.height+20);
        _kBxtContentLabel.textColor = [UIColor blackColor];
        self.cellheight = _kBxtLeftView.bottom+10;
    }else{
        [_kBxtAudioButton setHidden:NO];
        _kBxtLeftView.frame = CGRectMake(10, 25, 1, _kBxtAudioButton.bottom-25);
        _audioLb.text = listModel.timeLength;
        self.cellheight = _kBxtAudioButton.bottom+10;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
