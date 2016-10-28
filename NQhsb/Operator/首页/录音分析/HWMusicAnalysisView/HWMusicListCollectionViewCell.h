//
//  HWMusicListCollectionViewCell.h
//  Operator
//
//  Created by NeiQuan on 16/10/18.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWMusicquestionListModel;
@interface HWMusicListCollectionViewCell : UICollectionViewCell

@property(nonatomic,retain)HWMusicquestionListModel *questionModel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property(nonatomic,retain) NSIndexPath *indexpath;
//描述信息
@property (weak, nonatomic) IBOutlet UILabel *describeLable;

@end
