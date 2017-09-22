//
//  YMLoginController.h
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"



@interface YMLoginController : BaseViewController


//注册 tag == 1   修改密码 tag == 2  游客 返回 到 主页
@property(nonatomic,assign)NSInteger tag;

@property(nonatomic,assign)BOOL isToTabBar;

//隐藏返回键
@property(nonatomic,assign)BOOL isHiddenBackBtn;

//刷新网页block
@property(nonatomic,copy)void(^refreshWebBlock)();
@end
