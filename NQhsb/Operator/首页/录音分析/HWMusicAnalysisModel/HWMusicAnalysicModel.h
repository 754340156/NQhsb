//
//  HWMusicAnalysicModel.h
//  Operator
//
//  Created by NeiQuan on 16/10/17.
//  Copyright © 2016年 白小田. All rights reserved.
//

#import "BaseModel.h"

@interface HWMusicAnalysicModel : BaseModel

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *isShelves;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *dataId;

@end

//学习计划模板Model
@interface HWMusicAnalysicListModel : BaseModel


@property(nonatomic,assign) BOOL Haveselected;//用于统计是否被选中

@property(nonatomic,copy) NSString *dataId;
@property(nonatomic,copy) NSString *dtCreat;
@property(nonatomic,copy) NSString *remark;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *account;


@end

//模板生成问题分析列表model
@interface HWMusicquestionListModel : BaseModel

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *remark;//描述信息
@property(nonatomic,copy) NSString *dataId;

@property(nonatomic,copy) NSString *account;
@property(nonatomic,copy) NSString *dtCreat;//创建日期
@property(nonatomic,copy) NSString *type;

@property(nonatomic,copy) NSString *onPic;//背景图


@end

//模板获取题库
@interface HWMusicquestionBankModel : BaseModel

@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *describes;//描述信息
@property(nonatomic,copy) NSString *title;

@property(nonatomic,copy) NSString *dataId;
@property(nonatomic,copy) NSString *uanswer;//
@property(nonatomic,copy) NSString *score;

@property(nonatomic,copy) NSString *account;
@property(nonatomic,copy) NSString *dtCreat;
@property(nonatomic,copy) NSString *type;//	题类型0无答案题1单选2多选
@property(nonatomic,copy) NSString *indexs;

@property(nonatomic,copy) NSString *relevanceId; //关联id

@property(nonatomic,assign) BOOL haveselected; //用于记录是否点击了

@end
