//
//  YMUserManager.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface YMUserManager : NSObject


//单例对象
+(YMUserManager* )shareInstance;

//存储用户信息
- (void)saveUserInfoByUsrModel:(UserModel* )model;

//清空用户数据
- (void)removeUserInfo;

- (BOOL)isValidLogin;

//推出登陆界面
- (void)pushToLoginWithViewController:(UIViewController* )viewController;

//推出登陆界面 是否显示提示框
- (void)pushToLoginWithViewController:(UIViewController* )viewController isShowAlert:(BOOL)isShowAlert;
@end
