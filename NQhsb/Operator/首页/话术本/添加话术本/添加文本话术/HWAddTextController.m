//
//  HWAddTextController.m
//  Operator
//
//  Created by hai on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWAddTextController.h"

@interface HWAddTextController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *remarkTV;

@end

@implementation HWAddTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.title;
    self.rightButton.titleLabel.text = @"保存";
    [self.rightButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - setup

#pragma mark - target
//本地导入
- (IBAction)importAction:(id)sender
{
   
}
//保存
- (void)saveAction
{
    
}

@end
