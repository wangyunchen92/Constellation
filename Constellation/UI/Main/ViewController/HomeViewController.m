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
#import "YMUpdateView.h"
#import "HestoryDayView.h"
#import "PostWebViewController.h"
#import "HestoryDayViewController.h"
#import "MainSetViewController.h"


#import "HongbaoViewController.h"
#import "NewPagedFlowView.h"
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
@property (weak, nonatomic) IBOutlet UIButton *hongbaobutton;
@property (nonatomic, strong)NSString *redPacketUrl;
@property (nonatomic, strong)NewPagedFlowView *pageView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, assign)CGFloat newtableViewScroller;

@end

static CGFloat const  HestoryViewHeight = 303;
static CGFloat const  bannerViewHeight = 115;

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.canScroll = YES;
    self.desLabel.userInteractionEnabled = YES;
    self.scrollerView.showsVerticalScrollIndicator = NO;
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    self.viewModel = [[HomeViewModel alloc] init];

    [self createNavWithTitle:@"星座大全" leftImage:@"" rightImage:@"settings"];
    
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
        [self.boardView.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.boardView.reloadHeight);
        }];
    }];
    
    // 历史上的今天
    HestoryDayView *hView = [[HestoryDayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HestoryViewHeight)];
    [self.scrollerView addSubview:hView];
    [hView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollerView);
        make.top.equalTo(self.boardView.view.mas_bottom).with.offset(3);
        make.right.equalTo(self.scrollerView);
        make.height.mas_equalTo(HestoryViewHeight);
    }];
    
    hView.block_viewClick = ^(NSString * title) {
        PostWebViewController *webView = [[PostWebViewController alloc] init];
        webView.titleStr = title;
        webView.urlStr = @"https://yz.m.sm.cn/s";
        [self.navigationController pushViewController:webView animated:YES];
    };
    
    hView.block_more = ^ (NSArray *array) {
        HestoryDayViewController *hVC = [[HestoryDayViewController alloc] init];
        hVC.dataArray = array;
        [self.navigationController pushViewController:hVC animated:YES];
    };
    
    
    
        UIView *bannerView = [[UIView alloc] init];
        [self.scrollerView addSubview:bannerView];
        [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollerView);
            make.top.equalTo(hView.mas_bottom).with.offset(3);
            make.right.equalTo(self.scrollerView);
            make.height.mas_equalTo(bannerViewHeight);
        }];

        
        NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,115)];
        pageFlowView.backgroundColor = RGB(233, 233, 233);
        pageFlowView.delegate = self;
        pageFlowView.dataSource = self;
        pageFlowView.minimumPageAlpha = 0;
        pageFlowView.isCarousel = YES;
        pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
        pageFlowView.isOpenAutoScroll = YES;
        self.pageView = pageFlowView;
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 32, kScreenWidth, 8)];
        pageFlowView.pageControl = pageControl;
        [pageFlowView addSubview:pageControl];
        self.pageControl = pageControl;
        [bannerView addSubview:pageFlowView];
    

    if ([UserDefaultsTool getBoolWithKey:isMainBanner]) {
        
    } else {
        bannerView.hidden = YES;
        self.pageView.hidden = YES;
    }
    
    // 今日新闻
    
    UIView *newsTitleView = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"每日星座";
    [newsTitleView addSubview:label];
    newsTitleView.backgroundColor = [UIColor whiteColor];
    [self.scrollerView addSubview:newsTitleView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(newsTitleView);
        make.left.equalTo(newsTitleView).with.offset(15);
    }];
    [newsTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollerView);
        if ([UserDefaultsTool getBoolWithKey:isMainBanner]) {
            make.top.equalTo(bannerView.mas_bottom).with.offset(3);
        } else {
            make.top.equalTo(hView.mas_bottom).with.offset(3);
        }

        make.right.equalTo(self.scrollerView);
        make.height.equalTo(@44);
    }];
    
    
    self.tableNewView = [[NewTableViewController alloc] initWithType:@"index"];
    self.tableNewView.needScrollForScrollerView = NO;
    [self.scrollerView addSubview:self.tableNewView.view];
    [self.tableNewView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollerView);
        make.top.equalTo(newsTitleView.mas_bottom).with.offset(1);
        make.right.equalTo(self.scrollerView);
        make.bottom.equalTo(self.scrollerView);
        make.height.mas_equalTo(kScreenHeight-64-47-44);
    }];
    [self addChildViewController:self.tableNewView];
    
    // 显示初始星座
    if ([UserDefaultsTool getStringWithKey:constellationNumber] && ![[UserDefaultsTool getStringWithKey:constellationNumber]isEqualToString:@""]) {
        self.viewModel.model = self.viewModel.dataArray[[[UserDefaultsTool getStringWithKey:constellationNumber] integerValue] - 1];
        [self.viewModel.subject_getDate sendNext:@YES];
        
        @weakify(self)
        self.viewModel.block_reloadDate = ^{
            @strongify(self)
            [self reload];
        };
    } else {
        [self choseConstellationAction:nil];
    }
    
    if ([UserDefaultsTool getBoolWithKey:isRedPacketTest]) {
        self.viewModel.block_redPacket = ^(NSString *url, NSString *imageurl) {
            self.redPacketUrl = url;
           
            [[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:imageurl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.hongbaobutton.bounds];
                imageview.image = image;
                [self.hongbaobutton addSubview:imageview];
                [self.hongbaobutton setImage:image forState:UIControlStateNormal];
            }];
        };
        [self.view bringSubviewToFront:self.hongbaobutton];
        self.hongbaobutton.hidden = NO;
        [self.viewModel.subject_isRedPacket sendNext:@YES];
    } else {
        self.hongbaobutton.hidden = YES;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.pageView reloadData];
}

- (IBAction)hongbaoAction:(id)sender {
    HongbaoViewController *HVC = [[HongbaoViewController alloc] init];
    HVC.url = self.redPacketUrl;
    [self.navigationController pushViewController:HVC animated:YES];
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
        [self.viewModel.subject_getDate sendNext:@YES];
        @weakify(self)
        self.viewModel.block_reloadDate = ^{
            @strongify(self)
            [self reload];
        };
    };
    VC.blocl_dismiss = ^{
        if (!([self.viewModel.model.consteID intValue] > 0)) {
            ConstellaDetailModel *model = [self.viewModel.dataArray objectAtIndex:0];
            self.viewModel.model = model;
            [UserDefaultsTool setString:[NSString stringWithFormat:@"%ld",(long)1] withKey:constellationNumber];
            [self.viewModel.subject_getDate sendNext:@YES];
            @weakify(self)
            self.viewModel.block_reloadDate = ^{
                @strongify(self)
                [self reload];
            };
        }
    };
}

- (IBAction)pushDetail:(id)sender {
    ConsteDetailViewController *VC = [[ConsteDetailViewController alloc] initWithViewModel:[[ConsteDeatilViewModel alloc]init]];
    VC.viewModel.model = self.viewModel.model;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([UserDefaultsTool getBoolWithKey:isMainBanner]) {
        self.newtableViewScroller = self.boardViewHeight+164+HestoryViewHeight+6 + bannerViewHeight+3;
    } else {
        self.newtableViewScroller = self.boardViewHeight+164+HestoryViewHeight+6;
    }
    
    CGFloat offY = scrollView.contentOffset.y;
    if (offY < 0) {
        scrollView.contentOffset = CGPointZero;
    }
    
    if (scrollView.contentOffset.y >= self.newtableViewScroller) {
        scrollView.contentOffset = CGPointMake(0, self.newtableViewScroller);
        if (self.canScroll) {
            self.canScroll = NO;
            self.tableNewView.canScroll = YES;
        }
    } else {
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, self.newtableViewScroller);
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
    self.boardView.dataArray = self.viewModel.serverArray;
    [self.boardView reloadData];
    if (self.viewModel.model.consteJttz.length > 36) {
        NSString *string = [self.viewModel.model.consteJttz substringToIndex:36];
        self.desLabel.text = [NSString stringWithFormat:@"%@...[查看详情]",string];
    }

    self.imageView.image = IMAGE_NAME([ToolUtil imagetrans:[self.viewModel.model.consteID integerValue]]);
    self.nameLabel.text = self.viewModel.model.consteName;
}

- (void)navBarButtonAction:(UIButton *)sender {
    if (sender.tag == NBButtonRight) {
        MainSetViewController *MVC = [[MainSetViewController alloc] init];
        [self.navigationController pushViewController:MVC animated:YES];
    }
}


#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(kScreenWidth , 115);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.viewModel.bannerArray.count;
}

- (void)didSelectCell:(PGIndexBannerSubiew *)subView withSubViewIndex:(NSInteger)subIndex {
    
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        //        bannerView.layer.cornerRadius = 4;
        //        bannerView.layer.masksToBounds = YES;
    }
    [bannerView.mainImageView setImage:IMAGE_NAME([self.viewModel.bannerArray objectAtIndex:index])];
    return bannerView;
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
