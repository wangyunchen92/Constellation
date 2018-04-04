//
//  HaveStartView.m
//  Constellation
//
//  Created by Sj03 on 2018/3/30.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "HaveStartView.h"
#import "StartView.h"
#import "ConstellationModel.h"
@interface HaveStartView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *boardFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *boardSecendLabel;
@property (weak, nonatomic) IBOutlet UILabel *boardThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *boardFourLabel;
@property (weak, nonatomic) IBOutlet UILabel *boardFiveLabel;
@property (weak, nonatomic) IBOutlet StartView *firstStartView;
@property (weak, nonatomic) IBOutlet StartView *secendStartView;
@property (weak, nonatomic) IBOutlet StartView *threeStartView;
@property (weak, nonatomic) IBOutlet StartView *fourStartView;
@property (weak, nonatomic) IBOutlet UILabel *topFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *topSecendLabel;
@property (weak, nonatomic) IBOutlet UILabel *topthreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *topFourLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTwoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *topNameThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *topNameFourLabel;
@property (weak, nonatomic) IBOutlet UILabel *topNameTwoLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *topArrayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hiddenFirstImage;
@property (weak, nonatomic) IBOutlet UILabel *hiddenFirstLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hiddenLabelTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *topNameFirstLabel;

@property (nonatomic, assign)CGFloat changeHeight;
@end

@implementation HaveStartView

-(void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HaveStartView class]) owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = CGRectMake(0, 0, kScreenWidth, self.height);

}

- (void)getDateForeModel:(ConstellationModel *)model {
    
    self.boardSecendLabel.text = model.consteYunShi;
    self.boardThreeLabel.text = model.consteAiQing;
    self.boardFourLabel.text = model.consteGongZuo;
    
    self.boardFiveLabel.text = model.consteCaiFu;
    if ([model isKindOfClass:[ConstellaDayModel class]]) {
        [self getModelForToDay:model];
    }
    if ([model isKindOfClass:[ConstellaWeakModel class]]) {
        [self getModelForWeak:model];
    }
    if ([model isKindOfClass:[ConstellaMonthModel class]]) {
        
        [self getModelForMonth:model];
    }
    if ([model isKindOfClass:[ConstellaYearModel class]]) {
        [self getModelForYear:model];
    }
   

    if (self.type == 1) {
        self.topNameFourLabel.text = @"幸运日";
        self.hiddenFirstImage.hidden = YES;
        self.hiddenFirstLabel.hidden = YES;
        self.hiddenLabelTopConstraint.constant = -37;
        self.changeHeight  = -37;
        
        
    }
    if (self.type == 2) {
        self.topNameThreeLabel.hidden = YES;
        self.topthreeLabel.hidden = YES;
        self.topFourLabel.hidden = YES;
        self.topNameFourLabel.hidden = YES;
        self.topNameTwoLabel.text = @"缘分星座";
        self.viewTopConstraint.constant = -10;
        
        self.hiddenFirstImage.hidden = YES;
        self.hiddenFirstLabel.hidden = YES;
        self.hiddenLabelTopConstraint.constant = -37;
        self.changeHeight = -10 - 37;
        
    }
    
    if (self.type == 3) {
        self.labelTwoTopConstraint.constant = -48;
        self.labelTopConstraint.constant = -48;
        [self.topArrayLabel enumerateObjectsUsingBlock:^(UILabel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
        self.firstStartView.hidden = YES;
        self.secendStartView.hidden = YES;
        self.threeStartView.hidden = YES;
        self.fourStartView.hidden = YES;
        self.topNameFirstLabel.text = @"综合指数";
        self.topNameTwoLabel.text = @"爱情指数";
        self.topNameThreeLabel.text = @"财富指数";
        self.topNameFourLabel.text = @"工作指数";
        self.changeHeight = -48 -37;
        
        self.hiddenFirstImage.hidden = YES;
        self.hiddenFirstLabel.hidden = YES;
        self.boardFirstLabel.hidden  = YES;
        self.hiddenLabelTopConstraint.constant = -37;
    }
    
    self.reloadHeight = 184 + 51 * 5 + [self getLabelHeight] + self.changeHeight;
    NSLog(@"%f",self.reloadHeight);
}

- (CGFloat )getLabelHeight {
      __block  CGFloat height = 0;
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:self.boardFirstLabel,self.boardSecendLabel,self.boardThreeLabel,self.boardFourLabel,self.boardFiveLabel, nil];
    [array enumerateObjectsUsingBlock:^(UILabel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize labelSize = [obj sizeThatFits:CGSizeMake(kScreenWidth-30, MAXFLOAT)];
        height = height + ceil(labelSize.height) + 1;
    }];
    
    return height;
}


- (void)getModelForToDay:(ConstellaDayModel *)model {
    self.boardFirstLabel.text = model.consteDaynotice;
    [self.firstStartView getStartNumber:[model.summaryStar integerValue]];
    [self.secendStartView getStartNumber:[model.loveStar integerValue]];
    [self.threeStartView getStartNumber:[model.moneyStar integerValue]];
    [self.fourStartView getStartNumber:[model.workStar integerValue]];
    self.topFirstLabel.text = model.consteGrxz;
    self.topSecendLabel.text = model.consteLuckNum;
    self.topthreeLabel.text = model.consteLuckCol;
    self.topFourLabel.text = model.consteluckyTime;
    
}

- (void)getModelForWeak:(ConstellaWeakModel *)model {
    self.boardFirstLabel.text = model.consteDaynotice;
    [self.firstStartView getStartNumber:[model.summaryStar integerValue]];
    [self.secendStartView getStartNumber:[model.loveStar integerValue]];
    [self.threeStartView getStartNumber:[model.moneyStar integerValue]];
    [self.fourStartView getStartNumber:[model.workStar integerValue]];
    self.topFirstLabel.text = model.consteGrxz;
    self.topSecendLabel.text = model.consteLuckNum;
    self.topthreeLabel.text = model.consteLuckCol;
    self.topFourLabel.text = model.consteLuckDay;
}

- (void)getModelForMonth:(ConstellaMonthModel *)model {
    self.boardFirstLabel.text = model.consteDaynotice;
    [self.firstStartView getStartNumber:[model.summaryStar integerValue]];
    [self.secendStartView getStartNumber:[model.loveStar integerValue]];
    [self.threeStartView getStartNumber:[model.moneyStar integerValue]];
    [self.fourStartView getStartNumber:[model.workStar integerValue]];
    self.topFirstLabel.text = model.consteGrxz;
    self.topSecendLabel.text = model.consteYfxz;
}

- (void)getModelForYear:(ConstellaYearModel *)model {
    self.topFirstLabel.text = model.consteGeneral;
    self.topSecendLabel.text = model.consteLove;
    self.topthreeLabel.text = model.consteMoney;
    self.topFourLabel.text = model.consteWork;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
