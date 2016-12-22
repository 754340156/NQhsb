//
//  XTStringStatic.h
//  Operator
//
//  Created by 白小田 on 2016/11/4.
//  Copyright © 2016年 白小田. All rights reserved.
//

#ifndef XTStringStatic_h
#define XTStringStatic_h

#define kBxtNetWorkError @"请检查网络连接"

#define kBxtNetWorkFinish @"请求成功"

#define kTextViewLineSpacingSet NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];paragraphStyle.lineSpacing = 8;NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName: UIColorFromRGB(666666), NSParagraphStyleAttributeName: paragraphStyle};
#endif /* XTStringStatic_h */
