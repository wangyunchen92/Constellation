//
//  YMCreditModel.h
//  Daiba
//
//  Created by YouMeng on 2017/8/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseModel.h"

@interface YMCreditModel : BaseModel

//公积金
@property(nonatomic,strong)NSNumber* gjj;
//京东
@property(nonatomic,strong)NSNumber* jd;
//手机号认证
@property(nonatomic,strong)NSNumber* mobile_credit;
//淘宝
@property(nonatomic,strong)NSNumber* tb;
//芝麻信用
@property(nonatomic,strong)NSNumber* zmxy;

@property(nonatomic,strong)NSNumber* xxrz;
//
@property(nonatomic,strong)NSNumber* sbzh;


@end
