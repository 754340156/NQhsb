//
//  YWOperatorHeader.h
//  Operator
//
//  Created by NeiQuan on 16/10/13.
//  Copyright © 2016年 白小田. All rights reserved.
//

#ifndef YWOperatorHeader_h
#define YWOperatorHeader_h

#import "HWHttpManger.h" //网络请求二次封装
/**
 *  修改密码
 */
#define userupdatePassword    @"/user/updatePassword.do"

/**
 *  修改个人中心
 */
#define userupdatUser    @"/user/updateUser.do"

/**
 *  查看个人信息
 */
#define getUserData    @"/user/getUser.do"

/**
 *  用户退出登录
 */
#define Userlogout    @"/ulogin/logout.do"

/**
 *  用户订单充值  
 */
#define Userorder  @"/order/list.do"

/**
 *  首页数据
 */
#define homePageIndex  @"/recording/main.do"

/**
 *添加话术本
 */
#define homePageaddWords  @"/recording/addwords.do"
/**
 *充值获取订单
 */
#define  userorderAdd  @"/order/add.do"


/**
 *录音列表
 */
#define  questionlist   @"/question/list.do"

/**
 *删除摸个录音
 */
#define  MusicDelete   @"/question/delete.do"






#endif /* YWOperatorHeader_h */
