//
//  SectionHeadCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "SectionHeadCell.h"

@implementation SectionHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
+(instancetype)shareCell{
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil
             ]lastObject];
}

+(instancetype)shareCellWithTapBlock:(void(^)(SectionHeadCell * cell))tapBlock{
    SectionHeadCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    //添加响应事件
    [YMTool addTapGestureOnView:cell.contentView target:self selector:@selector(tapClick:) viewController:nil];
    cell.tapBlock = tapBlock;
    return cell;
}
+(void)tapClick:(UITapGestureRecognizer* )tap{
    SectionHeadCell* cell = (SectionHeadCell* )tap.view.superview;
    if (cell.tapBlock) {
        SectionHeadCell* cell = (SectionHeadCell* )tap.view.superview;
        cell.tapBlock(cell);
    }
}

@end
