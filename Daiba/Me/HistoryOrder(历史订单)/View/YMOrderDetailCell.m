//
//  YMOrderDetailCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/8.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMOrderDetailCell.h"
#import "YMDateTool.h"

@interface YMOrderDetailCell ()
//借款金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

//借款时间
@property (weak, nonatomic) IBOutlet UILabel *borrowTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shoudBackTimeLabel;

//还款时间
@property (weak, nonatomic) IBOutlet UILabel *backTimeLabel;

//状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
// 平台服务费
@property (weak, nonatomic) IBOutlet UILabel *platformMoneyLabel;
//贷款管理费
@property (weak, nonatomic) IBOutlet UILabel *loanManageMoneyLabel;
//逾期管理费
@property (weak, nonatomic) IBOutlet UILabel *overdueMoneyLabel;
//免息减免
@property (weak, nonatomic) IBOutlet UILabel *reduceMoneyLabel;

@end


@implementation YMOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)contactBtnClick:(id)sender {
    if (self.contactBlock) {
        self.contactBlock();
    }
}

-(void)setOrderModel:(YMOrderModel *)orderModel{
    _orderModel = orderModel;
    _moneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",orderModel.borrow_money];
    _statusLabel.text = [NSString orderStatusStrWithStatus:orderModel.status.integerValue];
    
    if (orderModel.status.integerValue == 7) {
        _statusLabel.textColor = RGB(246, 71, 71);
    }
    if (orderModel.status.integerValue == 6) {
        _statusLabel.textColor = RGB(153, 153, 153);
    }
    
    _borrowTimeLabel.text = [YMDateTool timeForDateFormatted:orderModel.create_time format:@"yyyy年MM月dd日"];
    //实际还款时间
    _backTimeLabel.text = [YMDateTool timeForDateFormatted:orderModel.back_time format:@"yyyy年MM月dd日"];
    //应还款时间
    _shoudBackTimeLabel.text = [YMDateTool timeForDateFormatted:orderModel.pay_time format:@"yyyy年MM月dd日"];
    
    //平台服务费
    _platformMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",orderModel.platform_money];
    //管理费
     _loanManageMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",orderModel.interest_money];
    //逾期金额
    _overdueMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",orderModel.overdue_money];
    //减免费
    _reduceMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",orderModel.reduce_money];

}

+(instancetype)shareCellWithContactBlock:(void(^)())contactBlock{
    YMOrderDetailCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.contactBlock = contactBlock;
    return cell;
}
@end
