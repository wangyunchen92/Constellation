//
//  YMPhoneIdentifyCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/14.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMPhoneIdentifyCell.h"

@implementation YMPhoneIdentifyCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
}
@end
