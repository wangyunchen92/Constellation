//
//  YMUserManager.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMUserManager.h"

@implementation YMUserManager

//单例对象
+(YMUserManager* )shareInstance{
    static  YMUserManager* _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YMUserManager alloc] init];
    });
    return _sharedInstance;
}

//存储用户信息
- (void)saveUserInfoByUsrModel:(UserModel* )model{
    if (model.uid) {
        //[kUserDefaults setObject:@"1422" forKey:kUid];
        [kUserDefaults setObject:model.uid forKey:kUid];
    }
    if (model.username) {
        [kUserDefaults setObject:model.username forKey:kUsername];
    }
    if (model.phone) {
        [kUserDefaults setObject:model.phone forKey:kPhone];
    }
    if (model.date) {
        [kUserDefaults setObject:model.date forKey:kDate];
    }
    if (model.token) {
        [kUserDefaults setObject:model.token forKey:kToken];
    }
    //支付宝  银行卡
    if (model.check1) {
        [kUserDefaults setObject:model.check1 forKey:kCheck1];
    }
    if (model.check2) {
        [kUserDefaults setObject:model.check2 forKey:kCheck2];
    }
    if (model.check3) {
        [kUserDefaults setObject:model.check3 forKey:kCheck3];
    }
    if (model.check4) {
        [kUserDefaults setObject:model.check4 forKey:kCheck4];
    }
    if (model.check5) {
        [kUserDefaults setObject:model.check5 forKey:kCheck5];
    }   
    [kUserDefaults synchronize];
}

- (void)removeUserInfo {
    
    [kUserDefaults setObject:@"" forKey:kUid];
    [kUserDefaults setObject:@"" forKey:kUsername];
    [kUserDefaults setObject:@"" forKey:kPhone];
    [kUserDefaults setObject:@"" forKey:kPasswd];
    [kUserDefaults setObject:@"" forKey:kToken];
    [kUserDefaults setObject:@"" forKey:kDate];
    
    [kUserDefaults setObject:@"" forKey:kPlatformRate];
    [kUserDefaults setObject:@"" forKey:kBorrowRate];
    [kUserDefaults setObject:@"" forKey:kBorrowMoney];
    [kUserDefaults setObject:@"" forKey:kCheck5];
    [kUserDefaults setObject:@"" forKey:kCheck4];
    [kUserDefaults setObject:@"" forKey:kCheck3];
    [kUserDefaults setObject:@"" forKey:kCheck1];
    [kUserDefaults setObject:@"" forKey:kCheck2];

    
    [kUserDefaults setObject:@"" forKey:kZfb_accountName];
    [kUserDefaults setObject:@"" forKey:kCheckStatus];
    [kUserDefaults setObject:@"" forKey:kCard_accountName];
    [kUserDefaults setObject:@"" forKey:kCard_realName];
    
    
    [kUserDefaults synchronize];
    
}
- (BOOL)isValidLogin{
    if ([[kUserDefaults valueForKey:kUid] integerValue] > 0) {
        return YES;
    }else{
        return NO;
    }
}

- (void)pushToLoginWithViewController:(UIViewController* )viewController {
    
    UIAlertController* alerC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有登陆，是否登陆？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        YMLoginController* lvc = [[YMLoginController alloc]init];
        YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
        lvc.hidesBottomBarWhenPushed = YES;
        [viewController presentViewController:nav animated:YES completion:nil];
        //[viewController.navigationController pushViewController:lvc animated:YES];
    }];
    [alerC addAction:cancelAction];
    [alerC addAction:sureAction];
    [viewController presentViewController:alerC animated:YES completion:nil];
    
}

- (void)pushToLoginWithViewController:(UIViewController* )viewController isShowAlert:(BOOL)isShowAlert{
    if (isShowAlert) {
        UIAlertController* alerC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有登陆，是否登陆？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            YMLoginController* lvc = [[YMLoginController alloc]init];
            YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
            lvc.hidesBottomBarWhenPushed = YES;
            [viewController presentViewController:nav animated:YES completion:nil];
            //[viewController.navigationController pushViewController:lvc animated:YES];
        }];
        [alerC addAction:cancelAction];
        [alerC addAction:sureAction];
        [viewController presentViewController:alerC animated:YES completion:nil];
    }else{
        YMLoginController* lvc = [[YMLoginController alloc]init];
        YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
        lvc.hidesBottomBarWhenPushed = YES;
        [viewController presentViewController:nav animated:YES completion:nil];
    }
    
}

@end
