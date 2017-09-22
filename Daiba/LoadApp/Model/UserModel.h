//
//  UserModel.h
//  挑食
//
//  Created by Lucky on 16/11/28.
//  Copyright © 2016年 赵振龙. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

//登陆的时间
@property(nonatomic,copy)NSString* date;
//用户名
@property(nonatomic,copy)NSString* phone;
//token
@property(nonatomic,copy)NSString* token;
//user_id
@property(nonatomic,copy)NSString* uid;
//用户名
@property(nonatomic,copy)NSString* username;

//审核状态
@property(nonatomic,strong)NSNumber* postion;

//三种日期方式
@property(nonatomic,strong)NSArray* date_select;
//平台费率
@property(nonatomic,assign)NSArray* platform_rate;


//订单时间
@property(nonatomic,copy)NSString* create_time;

//最高贷款额度
@property(nonatomic,assign)CGFloat credit_money;

//最高 最低 金额
@property(nonatomic,assign)CGFloat max_money;
@property(nonatomic,assign)CGFloat min_money;

//订单额度
@property(nonatomic,assign)CGFloat borrow_money;
//借钱利率
@property(nonatomic,assign)CGFloat borrow_rate;
//平台利率
//@property(nonatomic,assign)CGFloat platform_rate;


//借钱账号
@property(nonatomic,copy)NSString* money_account;

//
@property(nonatomic,copy)NSNumber* check1;
//
@property(nonatomic,copy)NSNumber* check2;
//
@property(nonatomic,copy)NSNumber* check3;

//
@property(nonatomic,copy)NSNumber* check4;
// 0初始 1通过 2拒绝 3复审待审
@property(nonatomic,copy)NSNumber* check5;

//0开始借款 1借款申请中 2借款成功 3借款失败 4还款成功
@property(nonatomic,strong)NSNumber* status;

//用户信息
@property(nonatomic,strong)NSArray* userInfo;



@end
