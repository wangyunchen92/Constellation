//
//  YMMoneStatusCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/7.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import "YMMoneStatusCell.h"


@interface YMMoneStatusCell ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;

@end

@implementation YMMoneStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setBorrowModel:(BorrowModel *)borrowModel{
    _borrowModel = borrowModel;
    if (borrowModel.status.integerValue == 5 || borrowModel.status.integerValue == 6 || borrowModel.status.integerValue == 7) {
       _moneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",borrowModel.back_money];
    }else{
       _moneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",borrowModel.borrow_money];
    }
}

-(void)setUsrModel:(UserModel *)usrModel{
    _usrModel = usrModel;
    //红色
    _statusLabel.text = [NSString statusByUserModel:usrModel];
    if (usrModel.status.integerValue == 7) {
        _statusLabel.textColor = RGB(246,71, 71);
    }
    //蓝色
    if (usrModel.status.integerValue == 2 || usrModel.status.integerValue == 4 || usrModel.status.integerValue == 5 || usrModel.status.integerValue == 6) {
       
        _statusLabel.textColor = RGB(0,145,255);
    }
    
     _cardLabel.text  = usrModel.money_account;
    if (_cardLabel.text.length >= 4) {
        _iconImgView.image = [self imageWithStr:_cardLabel.text subStr:[_cardLabel.text substringWithRange:NSMakeRange(0, 4)]];
    }
    
    
}
//-(NSString* )statusByUserModel:(UserModel *)usrModel{
//    if ((usrModel.status.integerValue == 0  || usrModel.status.integerValue == 1 )) {
//        return  @"借款处理中...";
//    }
//    if (usrModel.status.integerValue == 2 ) {
//        return  @"借款已到账";
//    }
//    if (usrModel.status.integerValue == 3 ) {
//        return  @"借款失败";
//    }
//    //开始还款
//    if (usrModel.status.integerValue == 4 ) {
//        return  @"当前应还金额";
//    }
//    //还款处理 申请
//    if (usrModel.status.integerValue == 5 ) {
//        return  @"还款处理中...";
//    }
//    //还款成功
//    if (usrModel.status.integerValue == 6 ) {
//        return  @"还款成功";
//    }
//    //还款失败
//    if (usrModel.status.integerValue == 7 ) {
//        return  @"还款失败，请重新还款";
//    }
//    return @"";
//}


-(UIImage* )imageWithStr:(NSString* )str subStr:(NSString* )subStr{
    if ([str containsString:subStr]) {
       return  [UIImage imageNamed:subStr];
    }
    return nil;
}
+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
}
@end
