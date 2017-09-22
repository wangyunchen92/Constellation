//
//  YMIdentityCell.m
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMIdentityCell.h"
#import "XCFileManager.h"

@implementation YMIdentityCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    [YMTool viewLayerWithView:self.modifyBtn cornerRadius:4 boredColor:DefaultNavBarColor borderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+(instancetype)shareCellWithModifyBlock:(void (^)(UIButton* btn))modifyBlock{
    YMIdentityCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.modifyBlock = modifyBlock;
    
    return cell;
}

- (IBAction)modifyBtnClick:(id)sender {
    //修改按钮点击了
    if (self.modifyBlock) {
        self.modifyBlock(sender);
    }
}

-(void)setIdcardModel:(IdCardModel *)idcardModel{
    _idcardModel = idcardModel;
    _nameLabel.text = [NSString stringWithFormat:@"姓名：%@",idcardModel.real_name ?: @""];
    _idNumLabel.text = [NSString stringWithFormat:@"身份证号：%@",idcardModel.card_number ?: @""] ;
    if (_idNumLabel.text.length > 8) {
         _idNumLabel.text = [NSString string:_idNumLabel.text replaceStrInRange:NSMakeRange(6, _idNumLabel.text.length - 6 - 1) withString:@"****************"];
    }
    if (_nameLabel.text.length >= 4) {
        _nameLabel.text = [NSString string:_nameLabel.text replaceStrInRange:NSMakeRange(3,  1) withString:@"*"];
    }
    if (![NSString isEmptyString:idcardModel.card_imgA]) {
        _idSureImgView.hidden = NO;

        UIImage* img = [XCFileManager getLocalFileWithFilePath:FrontIdImgFilePath fileKey:kFrontIdImg];
        _idImgView.clipsToBounds = YES;
        
        if (img) {
            _idImgView.image = img;
        }else{
            _idImgView.image = [UIImage imageNamed:@"实名认证"]; 
        }
    }
    
    [_modifyBtn setTitle:[NSString isEmptyString:idcardModel.card_number] ? @"填写":@"修改" forState:UIControlStateNormal];
    
}

@end
