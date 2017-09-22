//
//  LLPaySdk.h
//  LLPaySdk
//
//  Created by xuyf on 14-4-23.
//  Copyright (c) 2014年 LianLianPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const NSString* const kLLPaySDKBuildVersion;
extern const NSString *const kLLPaySDKVersion;

typedef enum LLPayResult {
    kLLPayResultSuccess = 0,    // 支付成功
    kLLPayResultFail = 1,       // 支付失败
    kLLPayResultCancel = 2,     // 支付取消，用户行为
    kLLPayResultInitError,      // 支付初始化错误，订单信息有误，签名失败等
    kLLPayResultInitParamError, // 支付订单参数有误，无法进行初始化，未传必要信息等
    kLLPayResultUnknow,         // 其他
}LLPayResult;

/* 可能返回的参数含义
 
 参数名                     含义
 result_pay                  支付结果
 oid_partner                 商户编号
 dt_order                    商户订单时间
 no_order                    商户唯一订单号
 ￼oid_paybill                 连连支付支付单号
 money_order                 交易金额
 ￼￼settle_date                 清算日期
 ￼￼info_order                  订单描述
 pay_type                    支付类型
 bank_code                   银行编号
 bank_name                   银行名称
 memo                        支付备注
 */

@interface LLPaySdk : NSObject

/**
 *  单例sdk add:20151106
 *
 *  @return 返回LLPaySdk的单例对象
 */
+ (LLPaySdk *)sharedSdk;


///支付申请
- (void)payApply: (NSDictionary *)paymentInfo inVC: (UIViewController *)vc completion:(void(^)(LLPayResult result, NSDictionary *dic))completion;

///签约申请
- (void)signApply: (NSDictionary *)paymentInfo inVC: (UIViewController *)vc completion:(void(^)(LLPayResult result, NSDictionary *dic))completion;

@end
