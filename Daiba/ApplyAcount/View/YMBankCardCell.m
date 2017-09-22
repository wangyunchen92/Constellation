//
//  YMBankCardCell.m
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMBankCardCell.h"

@interface YMBankCardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cardImgView;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;


//设置颜色
@property (weak, nonatomic) IBOutlet UIView *cardBgView;

@end
@implementation YMBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);

    [YMTool viewLayerWithView:self.cardBgView cornerRadius:4 boredColor:ClearColor borderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+(instancetype)shareCellWithModifyBlock:(void (^)(UIButton* btn))modifyBlock{
    YMBankCardCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.modifyBlock = modifyBlock;
    
    return cell;
}

- (IBAction)modifyBtnClick:(id)sender {
    if (self.modifyBlock) {
        self.modifyBlock(sender);
    }
}

-(void)setBankModel:(BankModel *)bankModel{
    _bankModel = bankModel;
    _cardNameLabel.text = bankModel.bank_name;
    if (bankModel.bank_account.length > 4) {
         _cardNumLabel.text  = [NSString string:bankModel.bank_account replaceStrInRange:NSMakeRange(0, bankModel.bank_account.length - 4) withString:@"**** **** **** "];
    }else{
        _cardNumLabel.text = bankModel.bank_account;
    }
   
       //背景图片
    [_cardImgView sd_setImageWithURL:[NSURL URLWithString:bankModel.centre_icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //背景色
    NSString* hexColor = bankModel.color;
    _cardBgView.backgroundColor = HEX(hexColor);
    
    [_modifyBtn setTitle:[NSString isEmptyString:bankModel.bank_account] ? @"填写":@"修改" forState:UIControlStateNormal];


}

@end
