//
//  YMWaitReviewCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/4.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWaitReviewCell.h"

@interface YMWaitReviewCell ()

@end

@implementation YMWaitReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selected = NO;
    
    //设置圆角
    [YMTool viewLayerWithView:self.sureBtn cornerRadius:8 boredColor:ClearColor borderWidth:1];
    
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)sureBtnClick:(id)sender {
    if (self.applyBlock) {
        self.applyBlock(sender);
    }
}

+(instancetype)shareCellWithApplyBlocl:(void (^)(UIButton* btn))applyBlock{
    YMWaitReviewCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.applyBlock = applyBlock;
   
    return cell;
}


@end
