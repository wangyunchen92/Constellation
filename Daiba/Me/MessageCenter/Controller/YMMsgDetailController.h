//
//  YMMsgDetailController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/20.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import <UIKit/UIKit.h>
#import "YMMsgModel.h"

@interface YMMsgDetailController : UIViewController

//刷新block
@property(nonatomic,copy)void(^refreshBlock)();
//消息模型
@property(nonatomic,strong)YMMsgModel* model;
@end
