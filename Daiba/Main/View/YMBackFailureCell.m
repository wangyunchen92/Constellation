//
//  YMBackFailureCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/8.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMBackFailureCell.h"
#import "XFStepView.h"

@interface YMBackFailureCell ()

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation YMBackFailureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [YMTool viewLayerWithView:_sureBtn cornerRadius:5 boredColor:ClearColor borderWidth:1];
    self.backgroundColor = BackGroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)sureBtnClick:(id)sender {
    if (self.refreshBlock) {
         self.refreshBlock(sender);
    }
}
+(instancetype)shareCellWithStutus:(int)status refreshBlock:(void(^)(UIButton* btn))refreshBlock{
    YMBackFailureCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    
    XFStepView* stepView = [[XFStepView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 60) Titles:[NSArray arrayWithObjects:@"申请成功", @"银行处理中", @"还款失败", nil]];
    [cell.topView  addSubview:stepView];
    
    cell.tipsLabel.text = @"1.请确认您当前绑定的中国农业银行（尾号0370）卡内余额是否大于100.18元;\n2.卡内余额充足，仍无法还款成功，建议您查看“如何还款成功”。";
    cell.refreshBlock = refreshBlock;
    
    return cell;
}

+(instancetype)shareCellWithUsrModel:(UserModel*)usrModel borrowModel:(BorrowModel* )borrowModel refreshBlock:(void(^)(UIButton* btn))refreshBlock{
    YMBackFailureCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    
    XFStepView* stepView = [[XFStepView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 60) Titles:[NSArray arrayWithObjects:@"申请成功", @"银行处理中", @"还款失败", nil]];
    [cell.topView  addSubview:stepView];
    
    stepView.isFailure = YES;
    stepView.stepIndex = 2;
    
    cell.tipsLabel.text = [NSString stringWithFormat:@"1.请确认您当前绑定的%@卡内余额是否大于%.2f元;\n2.卡内余额充足，仍无法还款成功，建议您查看“如何还款成功”。",usrModel.money_account,borrowModel.back_money];
    
    cell.refreshBlock = refreshBlock;
    
    return cell;
}

@end
