//
//  YMIdentityController.h
//  Daiba
//
//  Created by YouMeng on 2017/7/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDInfo.h"

@interface YMIdentityController : UIViewController

@property(nonatomic,assign)BOOL isShowNext;

//审核状态 --- 审核通过 不可修改身份证信息   只可修改 图片信息
@property(nonatomic,assign)BOOL isModify;

@property(nonatomic,copy)void(^refreshBlock)();

// 身份证信息 模型
@property (nonatomic,strong)IDInfo *idInfoModel;

// 身份证图像
@property (nonatomic,strong) UIImage *IDImage;

//是否有 之前上传过图片
@property(nonatomic,assign)BOOL isHaveImage;

//回调传递一个身份证模型
@property(nonatomic,copy)void(^idInfoBlock)(IDInfo* idModel);

@end
