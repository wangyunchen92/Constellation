//
//  YMBankListCollectionViewCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/29.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMBankListCollectionViewCell.h"

@implementation YMBankListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)shareCell {
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
}


@end
