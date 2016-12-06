//
//  YWWeakSelfInfoViewController.m
//  YWBiubiu
//
//  Created by NeiQuan on 16/8/16.
//  Copyright © 2016年 Mr-yuwei. All rights reserved.
//

#import "YWWeakSelfInfoViewController.h"
#import "ALiYunTool.h" //上传个人图片
@interface YWWeakSelfInfoViewController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    
    UIImage                    *_headerImage;//头像
    
}
@end

@implementation YWWeakSelfInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"更改头像";
    self.tableView.tableFooterView=[[ UIView alloc] init];
    [self.view setBackgroundColor:BXT_BACKGROUND_COLOR];
    [self makeRightButton];
    [self loadBasic];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
-(void)makeRightButton
{
    __weak typeof(self)weakself=self;
    UIButton *rightButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton .titleLabel.font=[UIFont systemFontOfSize:14];
    [rightButton setTitleColor:KTabBarColor forState:UIControlStateNormal];
    [rightButton addTarget:weakself action:@selector(postNetData) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    _userHeaderImage.layer.masksToBounds=YES;
    _userHeaderImage.layer.cornerRadius=40;
    
}
#pragma mark --需要根据登陆时候的数据显示个人信息
-(void)loadBasic
{
    
    if ([UserInfo account].headpic.length!=0)
    {
        [_userHeaderImage sd_setImageWithURL:[NSURL URLWithString:[UserInfo account].headpic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _headerImage=image;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [_userHeaderImage setImage:_headerImage];
        }];
       
    }
    if ([UserInfo account].nickname.length!=0)
    {
        _nameTextField.text=[UserInfo account].nickname;
    }
    if ([UserInfo account].mysign.length!=0)
    {
       _markTextfield.text=[UserInfo account].mysign;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[ UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10.0)];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return 0.01f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0)return 100;
    return 44;
}
#pragma mark --点击单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0)
    {
        UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择" ,nil];
        [sheet  showInView:self.view];
    }
    
}
#pragma mark --上传数据编辑个人中心

#pragma mark 相册选择
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            /**
             * UIImagePickerControllerSourceTypePhotoLibrary,
             UIImagePickerControllerSourceTypeCamera,
             UIImagePickerControllerSourceTypeSavedPhotosAlbum
             */
        case 0:{
            UIImagePickerController *picker=[[ UIImagePickerController alloc] init];
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            picker.editing=YES;
            picker.delegate=self;
            [self.navigationController presentViewController:picker animated:YES completion:^{
                
            }];
        }
            break;
        case 1:{
            
            UIImagePickerController *picker=[[ UIImagePickerController alloc] init];
            picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            picker.delegate=self;
            picker.editing=YES;
            [self.navigationController presentViewController:picker animated:YES completion:^{
            }];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark --private Method--相册功能
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *selectIma = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _headerImage=selectIma;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [_userHeaderImage setImage:_headerImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"])
    {
        return NO;
    }
    return YES;
}
#pragma mark --提交数据
-(void)postNetData
{
    [_nameTextField resignFirstResponder];
    [_markTextfield resignFirstResponder];
    //
    //正则匹配
    if ( _headerImage==nil)
    {
        [self showHint:@"请上传头像"];
        return;
    }
    if (_nameTextField.text.length==0)
    {
        [self showHint:@"请输入你的昵称"];
        return;
    }else if (_nameTextField.text.length>10){
        
        [self showHint:@"昵称过长"];
        return;
        
    }else if (_markTextfield.text.length==0)
    {
        [self showHint:@"请输入你的个性签名"];
        return;
    }
    [self showHudInView:self.view hint:@"加载中..."];
    [ALiYunTool asyncUploadImages:@[_headerImage] complete:^(NSArray<NSString *> *names, UploadImageState state) {
        [self  finish:names[0]];
    }];
}
#pragma mark --上传个人信息数据
-(void)finish:(NSString *)headerpic
{
    //[self showHudInView:self.view hint:nil];
    NSDictionary  *parameters=@{@"headpic":headerpic,
                                @"nickname":_nameTextField.text,
                                @"mysign":_markTextfield.text,
                                @"account":[UserInfo account].account,
                                @"token":[UserInfo account].token};

    [NetWorkHelp  netWorkWithURLString:userupdatUser
                            parameters:parameters
                          SuccessBlock:^(NSDictionary *dic)
     {
         [self hideHud];
         if ([dic[@"code"]integerValue]==0)
         {
             
        //这里需要保存用户的信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                XBAccessLoginTokenResult *result = [XBAccessLoginTokenResult mj_objectWithKeyValues:dic[@"response"][@"user"]];
                [UserInfo saveAccount:result];
                [self.navigationController popViewControllerAnimated:YES];
             });
         }else
         {
             [self showHint:dic[@"errorMessage"]];
         }
     } failBlock:^(NSError *error)
     {
       [self hideHud];
        [self showHint:@"网络连接失败"];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
