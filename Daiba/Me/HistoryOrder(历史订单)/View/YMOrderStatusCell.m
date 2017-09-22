//
//  YMOrderStatusCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/8.
//  Copyright © 2017年 YouMeng. All rights reserved.

#import "YMOrderStatusCell.h"
#import "NSString+Catogory.h"
#import "YMDateTool.h"

@interface YMOrderStatusCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation YMOrderStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
}

-(void)setModel:(YMOrderModel *)model{
    _model = model;
    _titleNameLabel.text = @"贷款金额";
    _moneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",model.borrow_money];
    _statusLabel.text = [NSString orderStatusStrWithStatus:model.status.integerValue];
    if (model.status.integerValue == 7) {
         _statusLabel.textColor = RGB(246, 71, 71);
    }
    if (model.status.integerValue == 6) {
        _statusLabel.textColor = RGB(153, 153, 153);
    }
    _dateLabel.text = [YMDateTool timeForDateFormatted:model.create_time format:@"yyyy年MM月dd日 HH:mm:ss"];
    
}

@end
