//
//  SalesjobCell.h
//  Operator
//
//  Created by 白小田 on 16/9/19.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BigForumModels.h"
#import "MainSearchFinishModels.h"
@interface SalesjobCell : UITableViewCell

@property (nonatomic,strong) BigForumList *list;

@property (nonatomic,strong) MainSearchFinishList *searchList;
@end
