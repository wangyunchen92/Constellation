//
//  HaveStartView.m
//  Constellation
//
//  Created by Sj03 on 2018/3/30.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "HaveStartView.h"
#import "StartView.h"
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

@property (nonatomic, assign)CGFloat changeHeight;
@end

@implementation HaveStartView

-(void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HaveStartView class]) owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = CGRectMake(0, 0, kScreenWidth, self.height);
}
- (void)getDateForeModel:(NSDictionary *)dic {
    self.boardFirstLabel.text = @"会收到爱的神秘礼物。";
    self.boardSecendLabel.text = @"喜欢的他虽然不喜欢你，却又能从别人那儿得到更多的关爱，感情面内心颇感平衡。支出趋于平缓，没有机会挥霍钱财，让你留住不少钱财。工作热情不足，斩获相对减少，应加强积极性，太过闲散易落后。";
    self.boardThreeLabel.text = @"异性缘佳，单身者有看对眼的对象别被动等待；恋爱中的人应多交流，稳固感情。";
    self.boardFourLabel.text = @"事业运很不好，像泄气皮球般，不太堆得动。想要混水摸鱼时要小心点，可别露出马脚啰！";
    self.boardFiveLabel.text = @"对金钱的支配欲及占有欲相当强。";

    if (self.type == 1) {
        self.topNameFourLabel.text = @"幸运日";
        
    }
    if (self.type == 2) {
        self.topNameThreeLabel.hidden = YES;
        self.topthreeLabel.hidden = YES;
        self.topFourLabel.hidden = YES;
        self.topNameFourLabel.hidden = YES;
        self.topNameTwoLabel.text = @"缘分星座";
        self.viewTopConstraint.constant = -24;
        self.changeHeight = -24;
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
        self.topFirstLabel.text = @"综合指数";
        self.topSecendLabel.text = @"爱情指数";
        self.topthreeLabel.text = @"财富指数";
        self.topFourLabel.text = @"工作指数";
        self.changeHeight = -48;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
