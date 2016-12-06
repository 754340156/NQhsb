//
//  HWUserBackController.m
//  Operator
//
//  Created by hai on 16/10/21.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWUserBackController.h"
#import "TZImagePickerController.h"
#import "PlaceholderTextView.h"
#import "HWEditPicCell.h"
#import "NSString+YWExtension.h"
//最多选取图片数
static NSInteger maxImageCount = 9;
//一排展示几张图片
static NSInteger picCount = 4;
@interface HWUserBackController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet PlaceholderTextView *remarkTV;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
/**  选择照片的数组 */
@property (nonatomic,strong) NSMutableArray * selectedPhotos;
/**  浏览照片的数组 */

@property (nonatomic,strong) NSMutableArray * selectedAssets;
@end

@implementation HWUserBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.titleText;
    [self setRemarkTV];
    [self setRightButton];
    [self setCollectionView];
}
#pragma mark - setup
- (void)setRemarkTV
{
    self.remarkTV.placeholder = @"请输入您的意见或建议(不少于5个字)";
}
- (void)setRightButton
{
    [self.rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setCollectionView
{
    self.selectedPhotos = [NSMutableArray array];
    self.selectedAssets = [NSMutableArray array];
    [self.collectionView registerClass:[HWEditPicCell class] forCellWithReuseIdentifier:NSStringFromClass([HWEditPicCell class])];
    self.collectionView.scrollEnabled = NO;
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedPhotos.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HWEditPicCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HWEditPicCell class]) forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == self.selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"tianjiazhaopian_icon"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = self.selectedPhotos[indexPath.row];
        cell.asset = self.selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row + 300;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.selectedPhotos.count) {
        [self pushImagePickerController];
    }else
    {
        //预览
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos index:indexPath.row];
        imagePickerVc.maxImagesCount = maxImageCount;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
            self.selectedAssets = [NSMutableArray arrayWithArray:assets];
            [_collectionView reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
#warning 图片的大小不确定
    CGFloat itemWidth = (WIDTH - 10 * (picCount+1)) / picCount;
    return CGSizeMake(itemWidth, itemWidth);
}
#pragma mark - TZImagePickerController
- (void)pushImagePickerController
{
    TZImagePickerController * imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImageCount delegate:self];
    imagePickerVC.selectedAssets = self.selectedAssets;
    imagePickerVC.allowPickingVideo = NO;
    imagePickerVC.allowPickingOriginalPhoto = NO;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
#pragma mark - TZImagePickerControllerDelegate
//选择完图片回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    [self.collectionView reloadData];
}
#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - target
- (void)submitAction
{
    [self.remarkTV resignFirstResponder];
    if ([NSString StringIsNULL:self.remarkTV.text])
    {
        [self showHint:@"请输入备注信息"];
        return;
    }else if (self.selectedPhotos.count==0)
    {
        [self showHint:@"您还没有添加图片"];
        return;
    }
    //发请求
}
//删除照片
- (void)deleteBtnClik:(UIButton *)sender
{
    [self.selectedPhotos removeObjectAtIndex:sender.tag - 300];
    [self.selectedAssets removeObjectAtIndex:sender.tag - 300];
    MJWeakSelf;
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag - 300 inSection:0];
        [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [weakSelf.collectionView reloadData];
    }];
}
#pragma mark - lazy
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
@end
