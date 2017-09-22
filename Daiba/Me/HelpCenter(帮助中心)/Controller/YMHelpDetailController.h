//
//  YMHelpDetailController.h
//  Daiba
//
//  Created by YouMeng on 2017/8/9.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMHelpModel.h"

@interface YMHelpDetailController : BaseViewController

//帮助模型
@property(nonatomic,strong)YMHelpModel* model;
@property(nonatomic,copy)NSString* typeId;

@end
