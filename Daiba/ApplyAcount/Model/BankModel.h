//
//  BankModel.h
//  Daiba
//
//  Created by YouMeng on 2017/8/3.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankModel : NSObject

//开户银行 账号 城市
@property(nonatomic,copy)NSString*  bank_account;
@property(nonatomic,copy)NSString*  bank_city;
@property(nonatomic,copy)NSString*  bank_city_id;
//开户银行名 预留电话
@property(nonatomic,copy)NSString*  bank_name;
@property(nonatomic,copy)NSString*  bank_phone;

//支持的银行 名 及电话
@property(nonatomic,copy)NSString* icon;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* phone;

//颜色 图标
@property(nonatomic,copy)NSString* color;
@property(nonatomic,copy)NSString* small_icon;
@property(nonatomic,copy)NSString* centre_icon;
@property(nonatomic,copy)NSString* big_icon;
@end
