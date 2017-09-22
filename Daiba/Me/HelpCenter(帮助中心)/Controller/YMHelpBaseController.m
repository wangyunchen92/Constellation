//
//  YMHelpBaseController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/9.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMHelpBaseController.h"
#import "YMHelpController.h"
#import "LLSegmentBarVC.h"
#import "YMHelpModel.h"

@interface YMHelpBaseController ()


@property (nonatomic,weak) LLSegmentBarVC * segmentVC;

@property(nonatomic,strong)NSMutableArray* titlesArr;
@end

@implementation YMHelpBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //请求数据
    [self requestDataWithApi:HelpListURL Param:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)creatUIWithTitlesArr:(NSMutableArray* )titlesArr{
    DDLog(@"titlsArr == %@",titlesArr);
    // 1 设置segmentBar的frame
    self.segmentVC.segmentBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);

    [self.view addSubview:self.segmentVC.segmentBar];
    //self.navigationItem.titleView = self.segmentVC.segmentBar;
    
    // 2 添加控制器的View
    self.segmentVC.view.frame = CGRectMake(0, 40 + 10, SCREEN_WIDTH, SCREEN_HEGIHT - NavBarTotalHeight - 40 - 10 );
//    self.segmentVC.view.backgroundColor = WhiteColor;
    [self.view addSubview:self.segmentVC.view];
    
    NSMutableArray* titles   = [[NSMutableArray alloc]init];
    NSMutableArray* childVcs = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < titlesArr.count ; i ++ ) {
        YMHelpController* yvc = [[YMHelpController alloc]init];
        YMHelpModel* model = titlesArr[i];
        yvc.name = model.name;
        yvc.dataArr = model.content;
        [titles addObject:model.name];
        [childVcs addObject:yvc];
    }
    DDLog(@"childViewControllers == %@  childVcs == %@",self.childViewControllers,childVcs);
    // 3 添加标题数组和控住器数组
    [self.segmentVC setUpWithItems:titles childVCs:childVcs];
    
    // 4  配置基本设置  可采用链式编程模式进行设置
    [self.segmentVC.segmentBar updateWithConfig:^(LLSegmentBarConfig *config) {
        config.sBBackColor = WhiteColor;
        config.itemNormalColor(RGBA(102, 102, 102, 1)).itemSelectColor(DefaultNavBarColor).indicatorColor(DefaultNavBarColor);
    }];
    
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg_64"] forBarMetrics:UIBarMetricsDefault];
    
}
// lazy init
- (LLSegmentBarVC *)segmentVC{
    if (!_segmentVC) {
        LLSegmentBarVC *vc = [[LLSegmentBarVC alloc]init];
        // 添加到到控制器
        [self addChildViewController:vc];
        _segmentVC = vc;
    }
    return _segmentVC;
}
-(NSMutableArray *)titlesArr{
    if (!_titlesArr) {
        _titlesArr = [[NSMutableArray alloc] init];
    }
    return _titlesArr;
}
#pragma mark - 网络请求
// 网络请求
-(void)requestDataWithApi:(NSString* )api Param:(NSMutableDictionary* )param {
    
    [[HttpManger sharedInstance]callHTTPReqAPI:api params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
        self.titlesArr = [YMHelpModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self creatUIWithTitlesArr:self.titlesArr];
    }];
}


@end
