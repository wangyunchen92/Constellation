//
//  RelationCell.m
//  Daiba
//
//  Created by YouMeng on 2017/7/29.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "RelationCell.h"

@implementation RelationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [YMTool viewLayerWithView:self.modifyBtn cornerRadius:4 boredColor:DefaultNavBarColor borderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)modifyBtnClick:(id)sender {
    
    if (self.modifyBlock) {
        self.modifyBlock(sender);
    }
}


+(instancetype)shareCellWithTitle:(NSString* )tilte modifyBlock:(void (^)(UIButton* btn))modifyBlock{
    RelationCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.typeNameLabel.text = tilte;
    cell.modifyBlock = modifyBlock;
    
    return cell;

}
@end
