//
//  QuotaCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "QuotaCell.h"

@implementation QuotaCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
@end
