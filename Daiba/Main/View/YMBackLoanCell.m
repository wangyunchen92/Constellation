//
//  YMBackLoanCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/7.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import "YMBackLoanCell.h"

@interface YMBackLoanCell ()

//标题
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
//应还款金额
@property (weak, nonatomic) IBOutlet UILabel *backMoneyLabel;
//借钱金额
@property (weak, nonatomic) IBOutlet UILabel *borrowMoneyLabel;
//利息等综合费用
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
//还款日期
@property (weak, nonatomic) IBOutlet UILabel *backDateLabel;
//距离还款日期
@property (weak, nonatomic) IBOutlet UILabel *overDueDayLabel;
//银行卡提示
@property (weak, nonatomic) IBOutlet UILabel *cardTipLabel;
//立即还款按钮
@property (weak, nonatomic) IBOutlet UIButton *backMoneyBtn;
//温馨提示
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

//设置背景颜色
@property (weak, nonatomic) IBOutlet UIView *backView;

@end


@implementation YMBackLoanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [YMTool viewLayerWithView:_backMoneyBtn cornerRadius:5 boredColor:ClearColor borderWidth:1];
    
    self.backView.backgroundColor = RGBA(245, 88, 0, 0.05);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)sumBtnClick:(UIButton*)sender {
    NSLog(@"点击计算器");
    if (self.sumBlock) {
        self.sumBlock(sender);
    }
    
}
- (IBAction)backMoneyBtnClick:(id)sender {
    if (self.backBlock) {
        self.backBlock(sender);
    }
}

+(instancetype)shareCellWithBorrowModel:(BorrowModel* )borrowModel backBlock:(void(^)(UIButton* btn))backBlock{
    YMBackLoanCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.borrowModel = borrowModel;
    cell.backBlock   = backBlock;
    
    if (borrowModel.status.integerValue == 4 ) {
        cell.statusLabel.text = @"当前应还金额";
    }
    
    cell.backMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",borrowModel.back_money];
    cell.interestLabel.text = [NSString stringWithFormat:@"利息等综合费用：%.2f元",borrowModel.interest_money];
    cell.borrowMoneyLabel.text = [NSString stringWithFormat:@"贷款金额：%.2f元",borrowModel.borrow_money];
    cell.backDateLabel.text = [NSString stringWithFormat:@"到期还款日：%@",[NSString isEmptyString:borrowModel.back_date] ? @"" : borrowModel.back_date];
    //绑定的银行卡
    NSArray* tmpStrArr = [borrowModel.money_account componentsSeparatedByString:@" "];
    cell.cardTipLabel.text = [NSString stringWithFormat:@"请将应还金额存入您的%@，然后点击“立即还款”",[NSString isEmptyString:tmpStrArr[0]] ? @"银行卡" : tmpStrArr[0]];//borrowModel.money_account
    //默认 - 代表未逾期  + 代表逾期
    if ([borrowModel.overdue_day integerValue] < 0) {
        cell.overDueDayLabel.text = [NSString stringWithFormat:@"距离到期还款日：还有%ld天",(long)-borrowModel.overdue_day.integerValue];
    }else{
         cell.overDueDayLabel.text = [NSString stringWithFormat:@"距离到期还款日：已逾期%ld天",(long)borrowModel.overdue_day.integerValue];
    }
   
    //已逾期
    if (borrowModel.status.integerValue == 2 && borrowModel.overdue_day.integerValue > 0) {
        cell.statusLabel.text = @"当前逾期金额";
        cell.statusLabel.textColor = RGB(246, 71, 71);
        cell.overDueDayLabel.text = [NSString stringWithFormat:@"已逾期天数：%ld天",(long)borrowModel.overdue_day.integerValue];
        //到期还款日
        [YMTool labelColorWithLabel:cell.backDateLabel font:Font(14) range: NSMakeRange(6,cell.backDateLabel.text.length - 6) color:DefaultNavBarColor];
        //逾期天数
        [YMTool labelColorWithLabel:cell.overDueDayLabel font:Font(14) range: NSMakeRange(6,cell.overDueDayLabel.text.length - 6) color:DefaultNavBarColor];
    }
    return cell;
                            
}


@end
