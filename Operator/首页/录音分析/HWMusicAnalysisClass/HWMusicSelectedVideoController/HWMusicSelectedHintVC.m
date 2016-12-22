//
//  HWMusicSelectedHintVC.m
//  Operator
//
//  Created by zhaozhe on 16/12/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWMusicSelectedHintVC.h"
#import "HWMusicMyVideoSearchVC.h"
#import "HWMusicSelectedModleController.h"
@interface HWMusicSelectedHintVC ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *footButton;

@end

@implementation HWMusicSelectedHintVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"选择录音";
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:KTabBarColor];
    
    self.footButton.layer.masksToBounds = YES;
    self.footButton.layer.borderWidth = 1;
    self.footButton.layer.borderColor = KTabBarColor.CGColor;
    [self.footButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
}

//跳过
- (IBAction)footAction:(id)sender
{
    HWMusicSelectedModleController *SelectedModuleVc=[[HWMusicSelectedModleController alloc] init];
    SelectedModuleVc.releatedId = @"";
    SelectedModuleVc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:SelectedModuleVc animated:YES];
}
//下一步
- (IBAction)nextAction:(id)sender
{
    HWMusicMyVideoSearchVC *searchVC = [[HWMusicMyVideoSearchVC alloc] init];
    searchVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

@end
