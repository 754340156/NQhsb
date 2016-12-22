//
//  HWAddPicController.m
//  Operator
//
//  Created by hai on 16/10/14.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "HWAddPicController.h"
#import "HWEditPicCell.h"
#import "TZImagePickerController.h"
#import "NSString+YWExtension.h"
//最多选取图片数
static NSInteger maxImageCount = 9;
//一排展示几张图片
static NSInteger picCount = 4;
@interface HWAddPicController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *remarkTV;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
/**  选择照片的数组 */
@property (nonatomic,strong) NSMutableArray * selectedPhotos;
/**  浏览照片的数组 */
@property (nonatomic,strong) NSMutableArray * selectedAssets;
@end

@implementation HWAddPicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"添加图片话术";
    self.backView.layer.shadowOpacity = 0.3;
    [self.rightButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    self.selectedPhotos = [NSMutableArray array];
    self.selectedAssets = [NSMutableArray array];
    [self.collectionView registerClass:[HWEditPicCell class] forCellWithReuseIdentifier:NSStringFromClass([HWEditPicCell class])];
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
    cell.deleteBtn.tag = indexPath.row + 200;
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
    CGFloat itemWidth = (WIDTH - 10 * picCount) / picCount;
    self.collectionHeight.constant = 30 + 2 * itemWidth;
    return CGSizeMake(itemWidth, itemWidth);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
#pragma mark - TZImagePickerController
//选取图片
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
#pragma mark - Action
//左上角删除图片按钮
- (void)deleteBtnClik:(UIButton *)sender
{
    [self.selectedPhotos removeObjectAtIndex:sender.tag - 200];
    [self.selectedAssets removeObjectAtIndex:sender.tag - 200];
    MJWeakSelf;
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag - 200 inSection:0];
        [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [weakSelf.collectionView reloadData];
    }];
}
//保存上传
#pragma mark --上传内容
- (void)saveAction
{
    [_titleTF resignFirstResponder];
    [_remarkTV resignFirstResponder];
    if (_selectedPhotos.count==0)
    {
        [self showHint:@"你还没有添加图片"];
        return;
    }
    MJWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ALiYunTool  asyncUploadImages:_selectedPhotos complete:^(NSArray<NSString *> *names, UploadImageState state) {
        if (state==UploadImageSuccess)
        {
         [weakSelf postData:names success:^{
             [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         } fail:^{
             [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         }];//将返回的url传递到本地服务器，字段需要用“,”隔开
        }
    }];
}
#pragma mark --将阿里云返回的图片URL上传到服务器
-(void)postData:(NSArray *)imageArray success:(void(^)())success fail:(void(^)())fail
{
    MJWeakSelf;
    NSString *content=[imageArray componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"account":[UserInfo account].account,
                          @"token":[UserInfo account].token,
                          @"wordsType":@"2",
                          @"title":_titleTF.text,
                          @"remark":_remarkTV.text,
                          @"content":content,
                          };
    [NetWorkHelp netWorkWithURLString:homePageaddWords
                           parameters:parameters
                         SuccessBlock:^(NSDictionary *dic) {
                             success();
                             if ([dic[@"code"] intValue] == 0) {
                                 //添加成功
                                 [weakSelf showHint:@"保存成功"];
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     [weakSelf.navigationController popViewControllerAnimated:YES];
                                 });
                             }else{
                                 [weakSelf showHint:dic[@"errorMessage"]];
                             }
                         } failBlock:^(NSError *error) {
                             fail();
                             [weakSelf showHint:@"网络连接错误"];
                         }];
}
#pragma mark - lazy
- (UIImagePickerController *)imagePickerVc
{
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
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    kTextViewLineSpacingSet
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
}
@end
