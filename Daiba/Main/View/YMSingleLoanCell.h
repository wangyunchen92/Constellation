//
//  YMSingleLoanCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/30.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMSingleLoanCell : UITableViewCell

@property(nonatomic,copy)void(^applyBlock)(UIButton* btn);
@property(nonatomic,copy)void(^sumBlock)(UIButton* btn);

//贷款周期
@property (weak, nonatomic) IBOutlet UILabel *dateSelectLabel;
//借款金额
@property(nonatomic,assign)CGFloat loanMoney;
//借款模型
@property(nonatomic,strong)UserModel* usrModel;

//确定按钮
@property (weak, nonatomic) IBOutlet UIButton *applyAccountBtn;


+(instancetype)shareCellWithUserModel:(UserModel* )model ApplyBlock:(void (^)(UIButton* btn))applyBlock;

@end
