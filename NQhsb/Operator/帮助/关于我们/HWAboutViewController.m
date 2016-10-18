//
//  HWAboutViewController.m
//  Operator
//
//  Created by NeiQuan on 16/10/13.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWAboutViewController.h"

@interface HWAboutViewController ()
{
    UITextView   *_textView;
}
@end

@implementation HWAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = @"关于我们";

    // Do any additional setup after loading the view.
    [self makeTextView];
}
#pragma mark --创建textView
-(void)makeTextView
{
   
    UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height)];
    textView.text=@"我遇过一些恋爱经验多的人，他们常常让我觉得，他们背后藏了一片满目疮痍的战场，我好像走过好多地雷炸过的洞一样，在那上面想要栽培出一朵玫瑰花来。我不是不觉得那些回忆不珍贵，我只是不想让我的回忆掺杂在那么惨烈的回忆当中而已";
    [self.view addSubview:textView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
