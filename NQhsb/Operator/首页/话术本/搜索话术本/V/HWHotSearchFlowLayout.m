//
//  HWHotSearchFlowLayout.m
//  Operator
//
//  Created by hai on 16/10/20.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWHotSearchFlowLayout.h"

@implementation HWHotSearchFlowLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)prepareLayout
{
    [super prepareLayout];
    self.sectionInset = UIEdgeInsetsMake(0, 25, 0, 25);
    self.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 20);
    self.minimumInteritemSpacing = 10;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for(int i = 1; i < [attributes count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        if (prevLayoutAttributes.indexPath.section == currentLayoutAttributes.indexPath.section) {
            NSInteger maximumSpacing = 15;
            NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
            if((origin + maximumSpacing + currentLayoutAttributes.frame.size.width) < self.collectionViewContentSize.width) {
                CGRect frame = currentLayoutAttributes.frame;
                frame.origin.x = origin + maximumSpacing;
                currentLayoutAttributes.frame = frame;
            }
        }
    }
    return attributes;
}
@end
