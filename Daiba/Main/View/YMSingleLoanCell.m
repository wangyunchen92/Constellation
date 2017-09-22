//
//  YMSingleLoanCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/30.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMSingleLoanCell.h"

@interface YMSingleLoanCell ()

//可借金额
@property (weak, nonatomic) IBOutlet UILabel *creditMoneyLabel;

//应还款金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//提示信息
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;


@end

@implementation YMSingleLoanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selected = NO;
    self.backgroundColor = BackGroundColor;
    self.contentView.backgroundColor = BackGroundColor;
    
    //设置圆角
    [YMTool viewLayerWithView:self.applyAccountBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
    
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)sumBtnClick:(id)sender {
    if (self.sumBlock) {
        self.sumBlock(sender);
    }
    
}
- (IBAction)applyBtnClick:(id)sender {
    NSLog(@"申请还款点击");
    if (self.applyBlock) {
        self.applyBlock(sender);
    }
    
}
+(instancetype)shareCellWithUserModel:(UserModel* )model ApplyBlock:(void (^)(UIButton* btn))applyBlock{
    YMSingleLoanCell* cell =  [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.applyBlock = applyBlock;
    cell.usrModel   = model;

      //提示信息赋值
    if (model.postion.integerValue == 99) {
        cell.tipsLabel.text = [NSString stringWithFormat:@"将借款到您的%@",model.money_account];
        [YMTool labelColorWithLabel:cell.tipsLabel font:Font(12) range:NSMakeRange(6, cell.tipsLabel.text.length - 6) color:DefaultNavBarColor];
        [cell.applyAccountBtn setTitle:@"立即借款" forState:UIControlStateNormal];
    }
    //断网默认利率 0.0005
    CGFloat borrow_rate = model.borrow_rate;
    if (borrow_rate <= 0) {
        borrow_rate = 0.005;
    }
    //拆分按钮  默认 14天
    NSArray* dateArr = model.date_select;
    if (dateArr.count == 0) {
        //没网给一个默认值
        dateArr = @[@"14"];
    }
    NSString* dateNum = dateArr[0];
    //默认可借金额 100
    CGFloat creditMoney = model.credit_money;
    if (creditMoney <= 0) {
        creditMoney = 1000;
    }
    
    
    cell.dateSelectLabel.text = [NSString stringWithFormat:@"%@天",dateNum];
    cell.creditMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",creditMoney];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",creditMoney * (1 + borrow_rate * [dateNum integerValue])];
    //可借金额
    cell.loanMoney = creditMoney;
    
    return cell;
}
@end
