//
//  YMRelationCell.m
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMRelationCell.h"

@implementation YMRelationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [YMTool viewLayerWithView:_modifyBtn cornerRadius:4 boredColor:DefaultNavBarColor borderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+(instancetype)shareCellWithModifyBlock:(void (^)(UIButton* btn))modifyBlock{
    YMRelationCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.modifyBlock = modifyBlock;
    
    return cell;

}
- (IBAction)modifyBtnClick:(id)sender {
    if (self.modifyBlock) {
        self.modifyBlock(sender);
    }
}

-(void)setAddresBookModel:(AddressBookModel *)addresBookModel{
    _addresBookModel = addresBookModel;
    
    _familyLabel.text = [NSString stringWithFormat:@"家人：%@",addresBookModel.family_phone ?addresBookModel.family_phone : @""];
    _friendLabel.text = [NSString stringWithFormat:@"朋友：%@",addresBookModel.friend_phone ? addresBookModel.friend_phone : @""]  ;
    _workmateLabel.text = [NSString stringWithFormat:@"同事：%@",addresBookModel.colleague_phone ? addresBookModel.colleague_phone : @""];
    
    [_modifyBtn setTitle:[NSString isEmptyString:addresBookModel.family_phone] ? @"填写":@"修改" forState:UIControlStateNormal];

}
@end
