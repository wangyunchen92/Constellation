//
//  YMBankCardController.h
//  Daiba
//
//  Created by YouMeng on 2017/8/3.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankModel.h"

@interface YMBankCardController : BaseViewController

//审核状态 --- 审核通过 不可修改银行卡信息
@property(nonatomic,assign)BOOL isCheckStatus;
@property(nonatomic,assign)BOOL isShowNext;
@property(nonatomic,assign)BOOL isModify;

@property(nonatomic,copy)void(^refreshBlock)();

//银行模型
@property(nonatomic,strong)BankModel* bankModel;


@end
