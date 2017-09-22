//
//  LoanApplyCell.h
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiuXSlider.h"
#import "UserModel.h"


@interface LoanApplyCell : UITableViewCell

@property(nonatomic,copy)void(^applyBlock)(UIButton* btn);

@property(nonatomic,copy)void(^sumBlock)(UIButton* btn);
//申请开户
@property (weak, nonatomic) IBOutlet UIButton *applyAccountBtn;

//选择日期
@property (weak, nonatomic) IBOutlet UIView *selectDateView;

//借款金额
@property(nonatomic,assign)CGFloat loanMoney;
//借款模型
@property(nonatomic,strong)UserModel* usrModel;

//选中的按钮
@property(nonatomic,strong)UIButton* selectBtn;

+(instancetype)shareCellWithUserModel:(UserModel* )model ApplyBlock:(void (^)(UIButton* btn))applyBlock;

@end
