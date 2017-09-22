//
//  YMForgetViewController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseViewController.h"

@interface YMForgetViewController : BaseViewController

//修改密码 忘记密码 公用一个控制器 接口不一致
@property(nonatomic,assign)PasswordType passwordType;

//手机号
@property(nonatomic,strong)NSString* phoneStr;
@end
