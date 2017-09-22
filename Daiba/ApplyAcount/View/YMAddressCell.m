//
//  YMAddressCell.m
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMAddressCell.h"

@implementation YMAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [YMTool viewLayerWithView:_modifyBtn cornerRadius:4 boredColor:DefaultNavBarColor borderWidth:1];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+(instancetype)shareCellWithModifyBlock:(void (^)(UIButton* btn))modifyBlock{
    YMAddressCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.modifyBlock = modifyBlock;
    
    return cell;
    
}
- (IBAction)modifyBtnClick:(id)sender {
    if (self.modifyBlock) {
        self.modifyBlock(sender);
    }
}

-(void)setAddrsModel:(AddressModel *)addrsModel{
    _addrsModel = addrsModel;
    //地址
    _homeAddLabel.text = addrsModel.live_area ;
    _homeDetailLabel.text = addrsModel.live_adress;
    
    _workAddLabel.text = addrsModel.work_area  ;
    _workDetailLabel.text = addrsModel.work_adress;
    
    _companyLabel.text = addrsModel.company ;
    _comTelLabel.text = addrsModel.company_phone;
    
    [_modifyBtn setTitle:[NSString isEmptyString:addrsModel.live_area] ? @"填写":@"修改" forState:UIControlStateNormal];
}
@end
