//
//  SalesjobDetailViewController.h
//  Operator
//
//  Created by 白小田 on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "NavViewController.h"

@interface SalesjobDetailViewController : NavViewController

kBxtPropertyStrong UIWebView *kBxtWebView;

kBxtPropertyStrong NSString *kBxtH5Url;

kBxtPropertyStrong NSString *kBxtTitle;

kBxtPropertyStrong NSString *relevanceId;

kBxtPropertyStrong NSString *type;
/**  是否可以分享,默认分享 */
@property(nonatomic,assign) BOOL isNotShare;

@end
