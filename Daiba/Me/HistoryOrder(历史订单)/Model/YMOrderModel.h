//
//  YMOrderModel.h
//  Daiba
//
//  Created by YouMeng on 2017/8/8.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMOrderModel : NSObject

@property(nonatomic,copy)NSString* id;

@property(nonatomic,copy)NSString* uid;

@property(nonatomic,assign)CGFloat money;

@property(nonatomic,assign)CGFloat borrow_money;
//借款利率
@property(nonatomic,assign)CGFloat borrow_rate;
//利率
@property(nonatomic,assign)CGFloat interest_money;

@property(nonatomic,assign)CGFloat platform_money;

@property(nonatomic,copy)NSString* borrow_use;

@property(nonatomic,copy)NSString* desc;

@property(nonatomic,copy)NSString* status;

@property(nonatomic,copy)NSString* create_time;

@property(nonatomic,copy)NSString* create_date;

@property(nonatomic,copy)NSString* update_time;
@property(nonatomic,copy)NSString* pay_time;
//逾期时间
@property(nonatomic,assign)CGFloat overdue_money;
//逾期时间
@property(nonatomic,assign)CGFloat reduce_money;


@property(nonatomic,copy)NSString* back_time;



@end
