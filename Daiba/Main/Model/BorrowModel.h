//
//  BorrowModel.h
//  Daiba
//
//  Created by YouMeng on 2017/8/4.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorrowModel : NSObject

//借款金额
@property(nonatomic,assign)CGFloat borrow_money;
//最高额度金额
@property(nonatomic,assign)CGFloat credit_money;
//逾期费用
@property(nonatomic,assign)CGFloat overdue_money;
//平台手续费用
@property(nonatomic,assign)CGFloat platform_money;
//利息
@property(nonatomic,assign)CGFloat interest_money;
//需要还款的
@property(nonatomic,assign)CGFloat back_money;


//借款订单状态
@property(nonatomic,strong)NSNumber* status;
//借款日期
@property(nonatomic,copy)NSString* create_time;

//收款账户
@property(nonatomic,copy)NSString* money_account;
//还款日期
@property(nonatomic,copy)NSString* back_date;

//负的表示距离还款日期天数,正的表示逾期天数
@property(nonatomic,copy)NSString* overdue_day;



@end
