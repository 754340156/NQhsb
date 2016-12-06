//
//  CollectionViewCell.h
//  Operator
//
//  Created by hai on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  HWCollectionModel;
@interface CollectionViewCell : UITableViewCell
/**  <#注释#> */
@property (nonatomic,strong) HWCollectionModel * model;
@end
