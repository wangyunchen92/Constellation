//
//  YMCreditCollectionCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMCreditCollectionCell.h"

@implementation YMCreditCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)shareCell {
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
}

@end
