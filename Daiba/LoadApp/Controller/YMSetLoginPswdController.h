//
//  YMSetLoginPswdController.h
//  CloudPush
//
//  Created by YouMeng on 2017/4/11.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMSetLoginPswdController : UIViewController

//登陆状态
@property(nonatomic,copy)void(^loginStatusBlock)();

@property(nonatomic,assign)BOOL isToTabBar;
@end
