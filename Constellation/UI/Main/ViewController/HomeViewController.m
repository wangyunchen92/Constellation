//
//  HomeViewController.m
//  Constellation
//
//  Created by Sj03 on 2018/3/27.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "HomeViewController.h"
#import "ChoseConstellationViewController.h"
#import "ConstellaDetailModel.h"
#import "HomeViewModel.h"
#import "ConsteDetailViewController.h"
#import "HomeBoardViewController.h"
#import "NewTableViewController.h"
#import "BaseScroller.h"


@interface HomeViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *NameMaskView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet BaseScroller *scrollerView;
@property (nonatomic, strong)HomeBoardViewController *boardView;
@property (nonatomic, strong)HomeViewModel *viewModel;
@property (nonatomic, assign)CGFloat boardViewHeight;
@property (nonatomic, assign)BOOL canScroll;
@property (nonatomic, strong)NewTableViewController *tableNewView;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canScroll = YES;
    self.desLabel.userInteractionEnabled = YES;
    self.viewModel = [[HomeViewModel alloc] init];
    [self createNavWithTitle:@"星座大全" leftText:@"" rightText:@""];
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.theSimpleNavigationBar.bottomLineView.hidden = YES;
    self.theSimpleNavigationBar.backgroundColor =UIColorFromRGB(0x5d2ebe);
    
    self.boardView = [[HomeBoardViewController alloc] init];
    self.boardView.menuViewStyle = WMMenuViewStyleLine;
    self.boardView.isShadow = NO;
    self.boardView.scrollEnable = NO;
    self.boardView.titleColorSelected = [UIColor blueColor];
    self.boardView.automaticallyCalculatesItemWidths = YES;
    self.boardView.progressWidth = kScreenWidth/5 -10;
    self.boardView.preloadPolicy = WMPageControllerPreloadPolicyHeight;
    self.boardView.cachePolicy = WMPageControllerCachePolicyHigh;
    
    [self.scrollerView addSubview:self.boardView.view];
    [self.boardView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollerView);
        make.top.equalTo(self.scrollerView).with.offset(164);
        make.right.equalTo(self.scrollerView);
        make.height.equalTo(@2000);
    }];
    [self addChildViewController:self.boardView];
    
    [RACObserve(self.boardView, reloadHeight) subscribeNext:^(id x) {
        self.boardViewHeight = self.boardView.reloadHeight;
    }];
    
    UIView *newsTitleView = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"今日新闻";
    [newsTitleView addSubview:label];
    newsTitleView.backgroundColor = [UIColor whiteColor];
    [self.scrollerView addSubview:newsTitleView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(newsTitleView);
        make.left.equalTo(newsTitleView).with.offset(15);
    }];
    [newsTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollerView);
        make.top.equalTo(self.boardView.view.mas_bottom).with.offset(3);
        make.right.equalTo(self.scrollerView);
        make.height.equalTo(@44);
    }];
    
    
    self.tableNewView = [[NewTableViewController alloc] initWithType:@"all"];
    [self.scrollerView addSubview:self.tableNewView.view];
    [self.tableNewView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollerView);
        make.top.equalTo(newsTitleView.mas_bottom).with.offset(1);
        make.right.equalTo(self.scrollerView);
        make.bottom.equalTo(self.scrollerView);
        make.height.mas_equalTo(kScreenHeight-64-47-44);
    }];
    [self addChildViewController:self.tableNewView];
    
    if ([UserDefaultsTool getStringWithKey:constellationNumber] && ![[UserDefaultsTool getStringWithKey:constellationNumber]isEqualToString:@""]) {
        self.viewModel.model = self.viewModel.dataArray[[[UserDefaultsTool getStringWithKey:constellationNumber] integerValue]];
        [self reload];
    } else {
        [self choseConstellationAction:nil];
    }

}


- (void)loadUIData {
    self.nameLabel.text = @"白羊座";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
}

- (IBAction)choseConstellationAction:(id)sender {
    ChoseConstellationViewController *VC = [[ChoseConstellationViewController alloc] init];
    [self presentViewController:VC animated:NO completion:nil];
    VC.block_sele = ^(NSInteger index) {
        ConstellaDetailModel *model = [self.viewModel.dataArray objectAtIndex:index-1];
        self.viewModel.model = model;
        [UserDefaultsTool setString:[NSString stringWithFormat:@"%ld",(long)index] withKey:constellationNumber];
        [self reload];
    };
}

- (IBAction)pushDetail:(id)sender {
    ConsteDetailViewController *VC = [[ConsteDetailViewController alloc] initWithViewModel:[[ConsteDeatilViewModel alloc]init]];
    VC.viewModel.model = self.viewModel.model;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
    if (offY < 0) {
        scrollView.contentOffset = CGPointZero;
    }
    
    if (scrollView.contentOffset.y >= self.boardViewHeight+164) {
        scrollView.contentOffset = CGPointMake(0, self.boardViewHeight+164);
        if (self.canScroll) {
            self.canScroll = NO;
            self.tableNewView.canScroll = YES;
        }
    } else {
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, self.boardViewHeight+164);
        }
    }
    self.scrollerView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    self.tableNewView.canScroll = NO;
}

- (void)reload {
    [self.boardView reloadData];
    NSString *string = [self.viewModel.model.consteJttz substringToIndex:36];
    self.desLabel.text = [NSString stringWithFormat:@"%@...[详情]",string];
    self.imageView.image = IMAGE_NAME([ToolUtil imagetrans:[self.viewModel.model.consteID integerValue]]);
    self.nameLabel.text = self.viewModel.model.consteName;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
