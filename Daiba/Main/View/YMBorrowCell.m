//
//  YMBorrowCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMBorrowCell.h"
#import "ExtendButton.h"


@interface YMBorrowCell ()

//平台
@property (weak, nonatomic) IBOutlet UILabel *platformMoneyLabel;
//收款账户
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
//还款日
@property (weak, nonatomic) IBOutlet UILabel *backDateLabel;
//已还金额
@property (weak, nonatomic) IBOutlet UILabel *backMoneyLabel;

//还款隐藏按钮
@property (weak, nonatomic) IBOutlet ExtendButton *descBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHeight;


//标题
@property (weak, nonatomic) IBOutlet UILabel *firstTitlLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitlLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdTitlLabel;
@property (weak, nonatomic) IBOutlet UILabel *fouthTitlLabel;




@end

@implementation YMBorrowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);

    [YMTool viewLayerWithView:_sureBtn cornerRadius:8 boredColor:ClearColor borderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)descBtnClick:(id)sender {
    DDLog(@"疑问描述信息");
    if (self.descBlock) {
        self.descBlock();
    }
}

+(instancetype)shareCell {
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
}
+(instancetype)shareCellWithBorrowModel:(BorrowModel* )model sureBlock:(void (^)(UIButton* btn))sureBlock{
    YMBorrowCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.sureBlock = sureBlock;
    cell.model = model;
    return cell;
}
- (IBAction)sureBtnClick:(id)sender {
    if (self.sureBlock) {
        self.sureBlock(sender);
    }
}
-(void)setModel:(BorrowModel *)model{
    _model = model;
    //借款
    if (model.status.integerValue >= 0 && model.status.integerValue <= 3 ) {
        //平台服务费
        self.platformMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",model.platform_money];
        self.cardLabel.text = [NSString isEmptyString:model.money_account] ? @"银行卡" : model.money_account;
        self.backDateLabel.text = [NSString isEmptyString:model.back_date] ? @"" : model.back_date;
    }
    //还款
    if (model.status.integerValue == 5 || model.status.integerValue == 6 || model.status.integerValue == 7 ) {
        //隐藏掉描述按钮
        _descBtn.hidden = YES;
        _descHeight.constant = 0;
        //平台服务费 -- 贷款金额
        self.platformMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",model.borrow_money];
        //银行卡信息 -- 利息等 综合费用
        self.cardLabel.text = [NSString stringWithFormat:@"%.2f元",model.interest_money];
        //还款日期  --  逾期管理费
        self.backDateLabel.text = [NSString stringWithFormat:@"%.2f元",model.overdue_money];
        // --  已还金额
        self.backMoneyLabel.text = @"0.00元";//model.back_money;
    }
}

-(void)setTitlesArr:(NSMutableArray *)titlesArr{
    _titlesArr = titlesArr;
    _firstTitlLabel.text = titlesArr[0];
    _secondTitlLabel.text = titlesArr[1];
    _thirdTitlLabel.text = titlesArr[2];
    if (titlesArr.count > 3) {
        _fouthTitlLabel.text = titlesArr[3];
    }
    
}

@end
