//
//  YMBankCardCell.h
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankModel.h"

@interface YMBankCardCell : UITableViewCell

@property(nonatomic,copy)void(^modifyBlock)(UIButton* btn);
//修改按钮
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@property(nonatomic,strong)BankModel* bankModel;

+(instancetype)shareCellWithModifyBlock:(void (^)(UIButton* btn))modifyBlock;

@end
