//
//  YWWeakSelfInfoViewController.h
//  YWBiubiu
//
//  Created by NeiQuan on 16/8/16.
//  Copyright © 2016年 Mr-yuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWWeakSelfInfoViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImage;//头像
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;//昵称
@property (weak, nonatomic) IBOutlet UITextField *markTextfield;//个性签名

@end
