//
//  LoanApplyCell.m
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "LoanApplyCell.h"


@interface LoanApplyCell ()

@property (weak, nonatomic) IBOutlet UIView *sliderView;
//贷款期限
@property (weak, nonatomic) IBOutlet UILabel *limitTimeLabel;
//到期应还款
@property (weak, nonatomic) IBOutlet UILabel *backLoanLabel;
//展示信息
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

//计算器
@property (weak, nonatomic) IBOutlet UIButton *sumBtn;

@property(nonatomic,strong)NSMutableArray* dateBtnArr;
//最小可借金额
@property(nonatomic,assign)CGFloat minMoney;
//index
@property(nonatomic,assign)int index;


@end

@implementation LoanApplyCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selected = NO;
    
    //设置圆角
    [YMTool viewLayerWithView:self.applyAccountBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
    
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//申请还款
- (IBAction)applyBtnClick:(id)sender {
    NSLog(@"申请开户点击");
    if (self.applyBlock) {
        self.applyBlock(sender);
    }
}
- (IBAction)sumBtnClick:(id)sender {
    if (self.sumBlock) {
        self.sumBlock(sender);
    }
}

+(instancetype)shareCellWithUserModel:(UserModel* )model ApplyBlock:(void (^)(UIButton* btn))applyBlock {
   LoanApplyCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.applyBlock = applyBlock;
    cell.usrModel   = model;
    //提示信息赋值
    if (model.postion.integerValue == 99) {
        cell.tipLabel.text = [NSString stringWithFormat:@"将借款到您的%@",model.money_account];
        [YMTool labelColorWithLabel:cell.tipLabel font:Font(12) range:NSMakeRange(6, cell.tipLabel.text.length - 6) color:DefaultNavBarColor];
        [cell.applyAccountBtn setTitle:@"立即借款" forState:UIControlStateNormal];
    }
    //拆分按钮
    NSArray* dateArr = model.date_select;
    if (dateArr.count == 0) {
        //没网给一个默认值
        dateArr = @[@"7",@"14",@"30"];
    }
    CGFloat margin = 20;
    CGFloat spaceX = 15;
    CGFloat spaceY = 0;
    CGFloat height = 30;
    CGFloat width = (SCREEN_WIDTH - 15 * 2 - margin * 2) /3;
    
    NSMutableArray* dateBtnArr = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < dateArr.count; i ++) {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(spaceX + i * (width + margin), spaceY, width, height)];
        [btn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        [YMTool viewLayerWithView:btn cornerRadius:0 boredColor:RGB(221, 221, 221) borderWidth:1];
        
        if (i == 1 || dateArr.count == 1) {
            btn.selected = YES;
            cell.selectBtn = btn;
            btn.backgroundColor = DefaultNavBarColor;
            [YMTool viewLayerWithView:btn cornerRadius:0 boredColor:ClearColor borderWidth:1];
        }
        btn.titleLabel.font = Font(14);
        [btn setTitleColor:WhiteColor forState:UIControlStateSelected];
        [btn setTitle:[NSString stringWithFormat:@"%@天",dateArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.selectDateView addSubview:btn];
        
        btn.tag = 100 + i;
        [dateBtnArr addObject:btn];
    }
    cell.dateBtnArr = dateBtnArr;
    NSMutableArray* numsArr = [[NSMutableArray alloc]init];
    CGFloat maxMoney = model.max_money;
    // --- bock 里面需要使用
   __block CGFloat minMoney = model.min_money;
    //默认利率 0.001
    CGFloat borrow_rate = model.borrow_rate;
    if (borrow_rate <= 0) {
        borrow_rate = 0.006;
    }
    //默认选中
     int defaultIndex = 0;
    //默认 最低可借金额 500
    if (model.min_money <= 0) {
        minMoney = 500;
        defaultIndex = 1;
    }
    // 可借金额 > 最多金额  --- 默认最大可借金额5000
    if (model.max_money < minMoney) {
        maxMoney = 5000;
    }
    //当最大可借金额 为 100 时，最小可借金额 为 0
    if (minMoney == maxMoney && minMoney > 0) {
        minMoney     = 0;
        defaultIndex = 1;
    }

    //最大可借金额
    if (maxMoney >= 100) {
        //100 元一档
        int count = (maxMoney - minMoney) * 0.01;
        int num = 0;
        for (int i = 0 ; i <= count; i ++) {
            num = minMoney + 100 * i ;
            [numsArr addObject:@(num).stringValue];
        }
        if (maxMoney == 100) {
            defaultIndex = 1;
        }else{
            defaultIndex = count/2;
        }
    }
    
    //默认取最大值 -- 可借金额
    if (model.credit_money == 0) {
         int count = (maxMoney - minMoney) * 0.01;
         defaultIndex = count;
    }
    //存储最小可借金额
    cell.minMoney = minMoney;
    //DDLog(@"numsArr == %@",numsArr);
    //cell.sliderView.frame.size.height == 100
   
    LiuXSlider* slider = [[LiuXSlider alloc] initWithFrame:CGRectMake(17, 0, SCREEN_WIDTH - 17 * 2, cell.sliderView.height) titles:numsArr firstAndLastTitles:@[@(minMoney).stringValue,@(maxMoney).stringValue] defaultIndex:defaultIndex sliderImage:[UIImage imageNamed:@"金额调动"]];
    //    slider.backgroundColor = NavBar_UnabelColor;
    [cell.sliderView addSubview:slider];
    
    //默认
     cell.index = defaultIndex;
    __weak LoanApplyCell* weakcell = cell;
    slider.block = ^(int index){
         NSLog(@"当前index==%d",index);
        weakcell.index = index;
        //获取天数
        NSString* dateNum = [weakcell.selectBtn.titleLabel.text substringToIndex:weakcell.selectBtn.titleLabel.text.length - 1];
        
        weakcell.backLoanLabel.text = [NSString stringWithFormat:@"到期应还：%.2f",(minMoney + 100 * index) * (1 + borrow_rate * [dateNum integerValue])];//model.borrow_rate
        //实际借款金额
        weakcell.loanMoney = minMoney + 100 * index;
        //天数
        [YMTool labelColorWithLabel:cell.backLoanLabel font:cell.backLoanLabel.font range:NSMakeRange(5, cell.backLoanLabel.text.length - 5) color:DefaultBtnColor];
    };
    
    //设置贷款期限颜色
   // cell.limitTimeLabel.text = [NSString stringWithFormat:@"贷款期限：1个月"];
   // [YMTool labelColorWithLabel:cell.limitTimeLabel font:cell.limitTimeLabel.font range:NSMakeRange(5, cell.limitTimeLabel.text.length - 5) color:DefaultBtnColor];
    
   // [cell backLoanLabelWithCell:cell index:defaultIndex];
    
    //实际借款金额
    weakcell.loanMoney = minMoney + 100 * defaultIndex;
    NSString* dateNum = [weakcell.selectBtn.titleLabel.text substringToIndex:weakcell.selectBtn.titleLabel.text.length - 1];

    //设置 初始值
    cell.backLoanLabel.text = [NSString stringWithFormat:@"到期应还：%.2f元",(minMoney + 100 * defaultIndex) * (1 + borrow_rate * [dateNum integerValue])];
    [YMTool labelColorWithLabel:cell.backLoanLabel font:cell.backLoanLabel.font range:NSMakeRange(5, cell.backLoanLabel.text.length - 5) color:DefaultBtnColor];
    
    return cell;
}
+(void)dateBtnClick:(UIButton* )btn{
//    DDLog(@"btn sel == %@",btn);
//    btn.selected = !btn.selected;
    LoanApplyCell* cell = (LoanApplyCell*)btn.superview.superview.superview;
    for (UIButton* btn in cell.dateBtnArr) {
        btn.selected = NO;
        [btn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
        [YMTool viewLayerWithView:btn cornerRadius:0 boredColor:RGB(221, 221, 221) borderWidth:1];
        btn.backgroundColor = ClearColor;
    }
    btn.selected = YES;
    cell.selectBtn = btn;
    btn.backgroundColor = DefaultNavBarColor;
    [YMTool viewLayerWithView:btn cornerRadius:0 boredColor:ClearColor borderWidth:1];
    
    UserModel* usrModel = cell.usrModel;
    CGFloat borrow_rate = usrModel.borrow_rate;
    if (borrow_rate <= 0) {
        borrow_rate = 0.0006;
    }
    NSString* dateNum = [btn.titleLabel.text substringToIndex:btn.titleLabel.text.length - 1];
    DDLog(@"dateNum === %@",dateNum);
    
     cell.backLoanLabel.text = [NSString stringWithFormat:@"到期应还：%.2f",(cell.minMoney + 100 * cell.index) * (1 + borrow_rate * [dateNum integerValue] )];
    //天数
    [YMTool labelColorWithLabel:cell.backLoanLabel font:cell.backLoanLabel.font range:NSMakeRange(5, cell.backLoanLabel.text.length - 5) color:DefaultBtnColor];
}
//-(void)backLoanLabelWithCell:(LoanApplyCell* )cell index:(int )index{
//    //设置 初始值
//    cell.backLoanLabel.text = [NSString stringWithFormat:@"到期应还：%.2f元",(500 + 100 * 0) * (1 + 0.001)];
//    [YMTool labelColorWithLabel:cell.backLoanLabel font:cell.backLoanLabel.font range:NSMakeRange(5, cell.backLoanLabel.text.length - 5) color:DefaultBtnColor];
//}


@end
