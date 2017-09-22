//
//  MainController.m
//  Daiba
//
//  Created by YouMeng on 2017/7/26.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMainController.h"
#import "SDCycleScrollView.h"
#import "YMBannerModel.h"
#import "LiuXSlider.h"
#import "LoanApplyCell.h"
#import "YMApplyMainController.h"
#import "YMMsgListController.h"
#import "YMWaitReviewCell.h"

#import <CoreLocation/CoreLocation.h>//定位

#import "YMIdentityController.h" //第一步身份认证
#import "YMBankCardController.h" //第二步绑定银行卡
#import "YMAddressController.h"  //第三步添加地址
#import "YMRelationController.h" //第四步绑定联系人
#import "YMVideoInfoController.h"//第五步实时录像视频

#import "YMLoanController.h"
#import "YMHeightTools.h"

#import "UserModel.h"
#import "BorrowModel.h"
#import "YMHeightTools.h"

#import "YMBorrowCell.h"
#import "YMMoneStatusCell.h"
#import "XFStepView.h"

#import "YMBackLoanCell.h"//开始还款
#import "YMWebViewController.h"

#import "YMSingleLoanCell.h"
#import "YMBackFailureCell.h"

#import "CustomDetectViewController.h"
#import <MGBaseKit/MGBaseKit.h>
#import <MGLivenessDetection/MGLivenessDetection.h>


@interface YMMainController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,CLLocationManagerDelegate>

@property(nonatomic,strong)UIImageView *navBarHairlineImageView;
//去掉导航
@property(nonatomic,strong)UIImageView* barImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//图片数组
@property(nonatomic,strong)NSMutableArray* imgsArr;
//消息中心
@property(nonatomic,strong)UIButton* messageBtn;
@property(nonatomic,strong)UILabel*  mesgNumLabel;

@property(nonatomic,strong)NSNumber* unreadMsgCount;

//用户模型
@property(nonatomic,strong)UserModel* usrModel;
//借款模型数据
@property(nonatomic,strong)BorrowModel* borrowModel;
//定位
@property (nonatomic, strong)CLLocationManager* locationManager;
@end

@implementation YMMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建轮播图
    [self creatcycleScrollView];
    //初始化界面
    [self modifyView];
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];;
}

-(void)modifyView {
    //处理导航 透明问题
    _barImageView = self.navigationController.navigationBar.subviews.firstObject;
    _barImageView.alpha = 0;
    self.tableView.backgroundColor = BackGroundColor;
    
    YMWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestUserStatusInfoWithIsLoading:NO];
    }];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_barImageView ) {
        _barImageView = self.navigationController.navigationBar.subviews.firstObject;
        _barImageView.alpha = 0;
    }
    //再定义一个imageview来等同于这个黑线
    _navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    _navBarHairlineImageView.hidden = YES;
    //请求借款状态
    [self requestUserStatusInfoWithIsLoading:NO];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _navBarHairlineImageView.hidden = NO;
    //恢复之前的导航色
    _barImageView.alpha = 1;
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            NSLog(@"requestAlwaysAuthorization");
            [_locationManager requestWhenInUseAuthorization];
        }
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#warning debug - 上线删除
//-(UserModel *)usrModel{
//    if (!_usrModel) {
//        _usrModel = [[UserModel alloc]init];
//        _usrModel.postion = @5;
//    }
//    return _usrModel;
//}
-(void)requestUserStatusInfoWithIsLoading:(BOOL)isLoading{
    if ([[YMUserManager shareInstance] isValidLogin]) {
        NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
         [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
         [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
        [[HttpManger sharedInstance]callHTTPReqAPI:getUsrStatusURL params:param view:self.view loading:isLoading tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
            
            self.usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"][@"account"]];
            self.borrowModel = [BorrowModel mj_objectWithKeyValues:responseObject[@"data"][@"borrow"]];
            //记录用户状态
            [kUserDefaults setObject:self.usrModel.postion forKey:kPostion];
            [kUserDefaults synchronize];
#warning - 测试订单状态
            // self.usrModel.postion = @5;
            [self.tableView reloadData];
        }];
    }else{
        //未登陆默认情况
        [[HttpManger sharedInstance]callHTTPReqAPI:getConfigInfoURL params:nil view:self.view loading:isLoading tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
            
            self.usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.borrowModel = [BorrowModel mj_objectWithKeyValues:responseObject[@"data"][@"borrow"]];
#warning - 测试订单状态
            [self.tableView reloadData];
        }];
    }
    DDLog(@"status == %d",[kUserDefaults boolForKey:kisSuccessBackMoney]);
}

#pragma mark - 创建滚动试图
-(void)creatcycleScrollView{
    //本地图片
    NSMutableArray* imgsArr =  @[@"banner1.jpg",@"banner2.jpg"].mutableCopy;
    SDCycleScrollView* sdSycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.49) imageNamesGroup:imgsArr];
//    sdSycleView.delegate = self;
    sdSycleView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    sdSycleView.currentPageDotColor = WhiteColor;
    sdSycleView.pageDotColor        = RGBA(255, 255, 255, 0.5);
    sdSycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    sdSycleView.placeholderImage   = [UIImage imageNamed:@"banner1.jpg"];
    //没有图片隐藏
    self.tableView.tableHeaderView = sdSycleView;
}
#pragma mark -  Location and Delegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    if (location) {
        [kUserDefaults setObject:@(coordinate.latitude) forKey:kLatitude];
        [kUserDefaults setObject:@(coordinate.longitude) forKey:kLongitude];
        [kUserDefaults synchronize];
        
        // 2.停止定位
        [manager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    DDLog(@"error === %@",error);
    if ([CLLocationManager locationServicesEnabled]  //确定用户的位置服务启用
        && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    {
        [YMTool presentAlertViewWithTitle:@"提示" message:@"您的定位服务没有打开，请在设置中开启" cancelTitle:@"取消" cancelHandle:^(UIAlertAction *action) {
            
        } sureTitle:@"确定" sureHandle:^(UIAlertAction * _Nullable action) {
            // 跳转到设置界面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                // url地址可以打开
                [[UIApplication sharedApplication] openURL:url];
            }
        } controller:self];
    }else{
        UIAlertView* alerView = [[UIAlertView alloc]initWithTitle:@"定位失败" message:@"网络连接失败，请检查网络！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alerView show];
    }
    
    // 2.停止定位
    [manager stopUpdatingLocation];
}

#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    DDLog(@"图片轮播点击了 %ld",(long)index);
}
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    // DDLog(@"图片轮播滚动了 %ld",(long)index);
}
#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [YMHeightTools getCellHeightWithUsrModel:self.usrModel indexpath:indexPath];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.usrModel.postion.integerValue == 99) {
        //0 - 1 - 2 - 3
        if (self.usrModel.status.integerValue < 4 && self.usrModel.status.integerValue >= 0) {
            if ([kUserDefaults boolForKey:kisSuccessLoan] == YES && self.usrModel.status.integerValue == 2) {
                return 1;
            }else{
               return 2;
            }
        }
        // 5 - 6 还款申请中 还款成功
        if (self.usrModel.status.integerValue == 5
            ||(self.usrModel.status.integerValue == 7 && [kUserDefaults boolForKey:kisFailureBackLoan] == NO)) {
            return 2;
        }
        if ((self.usrModel.status.integerValue == 7 && [kUserDefaults boolForKey:kisFailureBackLoan] == YES)) {
            return 1;
        }
    }
        return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMWeakSelf;
    //提交资料等待审核 -- 样式不一样
    if (self.usrModel.postion.integerValue == 66) {
        YMWaitReviewCell* cell = [YMWaitReviewCell shareCellWithApplyBlocl:^(UIButton *btn) {
            //跳转到免息
            weakSelf.tabBarController.selectedIndex = 1;
        }];
        return cell;
    }
    if (self.usrModel.postion.integerValue == 77) {
        YMWaitReviewCell* cell = [YMWaitReviewCell shareCellWithApplyBlocl:^(UIButton *btn) {
            //跳转到修改资料
            [self pushToController:[YMApplyMainController new] title:@"修改资料，立即申请开户" isShowNext:NO isModify:YES];
        }];
        cell.statusLabel.text = @"抱歉，您提交的审核未通过！";
        cell.tipLabel.text =[NSString stringWithFormat:@"您的开户资料审核失败，第%@步信息有误，请重新提交正确开户信息。",[self getCheckStepWithUsrModel]] ;
        cell.iconImgView.image =[UIImage imageNamed:@"审核失败"];
        [cell.sureBtn setTitle:@"修改资料再次提交" forState:UIControlStateNormal];
        return cell;
    }
    //借款还款  ----- 两个分区
    if (self.usrModel.postion.integerValue == 99 ) {
        //0开始借款 1借款申请中 2借款成功 3借款失败    5还款申请中 6 还款成功
        if (self.usrModel.status.integerValue  == 0  ||
            self.usrModel.status.integerValue  == 1  ||
            (self.usrModel.status.integerValue == 2 && [kUserDefaults boolForKey:kisSuccessLoan] == NO) ||
            self.usrModel.status.integerValue  == 3  ||
            self.usrModel.status.integerValue  == 5  //还款申请中
            ) {//还款成功(self.usrModel.status.integerValue == 6 && [kUserDefaults boolForKey:kisSuccessBackMoney] == NO)
            if (indexPath.section == 0) {
                YMMoneStatusCell* cell = [YMMoneStatusCell shareCell];
                cell.usrModel = self.usrModel;
                cell.borrowModel = self.borrowModel;
            
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            //第一个分区
            }else{
                YMBorrowCell* cell = [YMBorrowCell shareCellWithBorrowModel:self.borrowModel sureBlock:^(UIButton *btn) {
                    if (weakSelf.usrModel.status.integerValue == 2) {
                        [kUserDefaults setBool:YES forKey:kisSuccessLoan];
                        [kUserDefaults synchronize];
                        
                        [btn setTitle:@"立即还款" forState:UIControlStateNormal];
                        [self.tableView reloadData];
                    }
                    else{
                        NSLog(@"点击啦按钮");
                        [weakSelf requestUserStatusInfoWithIsLoading:YES];
                    }
                }];
                // 平台服务费
                cell.descBlock = ^{
                    [weakSelf pushToSumFeeController];
                };
                if ((self.usrModel.status.integerValue < 4 && self.usrModel.status.integerValue >= 0)) {
                    
                    cell.bottomViewHeight.constant = 0;
                    cell.bottomView.hidden = YES;
                }else{
                    cell.titlesArr = @[@"贷款金额",@"利息等综合费用",@"逾期管理费",@"已还金额"].mutableCopy;
                }
                // 第一次借款成功 会显示一次 我知道了 -- 借款成功 点击立即还款
                if (self.borrowModel.status.integerValue == 2 || self.borrowModel.status.integerValue == 6) {
                    if ([kUserDefaults boolForKey:kisSuccessLoan] == NO) {
                        [cell.sureBtn setTitle:@"我知道了" forState:UIControlStateNormal];
                    }
                    if ([kUserDefaults boolForKey:kisSuccessBackMoney] == NO) {
                        [cell.sureBtn setTitle:@"我知道了" forState:UIControlStateNormal];
                    }
                }
                //借款进度
                XFStepView* stepView = [[XFStepView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 60) Titles:[NSArray arrayWithObjects:@"申请成功", @"银行处理中", @"到账成功", nil]];
                if (self.borrowModel.status.integerValue < 3) {
                    stepView.stepIndex = (int)self.borrowModel.status.integerValue;
                }
                [cell.topView  addSubview:stepView];

                //还款处理中
                if (self.usrModel.status.integerValue == 5){
                    stepView.stepIndex = 1;
                     [cell.sureBtn setTitle:@"刷新还款结果" forState:UIControlStateNormal];
                }
                //还款成功
                if (self.usrModel.status.integerValue == 6){
                    stepView.stepIndex = 2;
                    // [cell.sureBtn setTitle:@"刷新还款结果" forState:UIControlStateNormal];
                }
    
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    //4 开始还款  7 还款失败  逾期还款2
    if ((self.usrModel.postion.integerValue == 99  && self.usrModel.status.integerValue == 4) ||
        (self.usrModel.postion.integerValue == 99  && self.usrModel.status.integerValue == 2 && [kUserDefaults boolForKey:kisSuccessLoan] ) ||
        (self.usrModel.postion.integerValue == 99  && self.usrModel.status.integerValue == 7 && [kUserDefaults boolForKey:kisFailureBackLoan] )){//失败还款 和 开始还款一致
        YMBackLoanCell* cell = [YMBackLoanCell shareCellWithBorrowModel:self.borrowModel backBlock:^(UIButton *btn) {
            //立即还款
            [weakSelf requestBackMoney];
        }];
        //费率计算
        cell.sumBlock = ^(UIButton *sumBtn) {
            [weakSelf pushToSumFeeController];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    //还款失败 第一次
    if (self.usrModel.postion.integerValue == 99  && self.usrModel.status.integerValue == 7 && [kUserDefaults boolForKey:kisFailureBackLoan]  == NO){
        if (indexPath.section == 0) {
            YMMoneStatusCell* cell = [YMMoneStatusCell shareCell];
            cell.usrModel = self.usrModel;
            cell.borrowModel = self.borrowModel;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            //第一个分区
        }else{
            YMBackFailureCell* cell = [YMBackFailureCell shareCellWithUsrModel:self.usrModel borrowModel:self.borrowModel refreshBlock:^(UIButton *btn) { }];
            cell.refreshBlock = ^(UIButton *btn) {
                 DDLog(@"点击知道啦 btn == %@",btn);
                [kUserDefaults setBool:YES forKey:kisFailureBackLoan];
                [kUserDefaults synchronize];
                [self.tableView reloadData];
                
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    //已还钱 -- 立即借款 99 -1  99 3//借款失败   还款成功     还款失败
    if ((self.usrModel.postion.integerValue == 99  && self.usrModel.status.integerValue == -1 )||
        (self.usrModel.postion.integerValue == 99  && self.usrModel.status.integerValue == 3)  ||
        (self.usrModel.postion.integerValue == 99  && self.usrModel.status.integerValue == 6 && [kUserDefaults boolForKey:kisSuccessBackMoney] == NO)  ) {
        //只有一种日期显示
        if (self.usrModel.date_select.count == 1 || self.usrModel.max_money <= 0) {
            YMSingleLoanCell* cell = [YMSingleLoanCell shareCellWithUserModel:self.usrModel ApplyBlock:^(UIButton *btn) {
                [self pushToLoanMoneyControllerWithButton:btn certainClass:[YMSingleLoanCell class]];
            }];
            cell.sumBlock = ^(UIButton* sumBtn){
                DDLog(@"点击啦费率");
                [weakSelf pushToSumFeeController];
            };
            
            if (self.usrModel.status.integerValue == - 1 || self.usrModel.status.integerValue == 6) {
                [cell.applyAccountBtn setTitle:@"立即借款" forState:UIControlStateNormal];
                
            }
            return cell;
        }
        
         LoanApplyCell* cell = [LoanApplyCell shareCellWithUserModel:self.usrModel ApplyBlock:^(UIButton *btn) {
             DDLog(@"立即借款");
             [self pushToLoanMoneyControllerWithButton:btn certainClass:[LoanApplyCell class]];
         }];
        if (self.usrModel.status.integerValue == - 1 || self.usrModel.status.integerValue == 6) {
            [cell.applyAccountBtn setTitle:@"立即借款" forState:UIControlStateNormal];
            
        }
        cell.sumBlock = ^(UIButton *btn) {
            DDLog(@"点击啦费率计算");
            [weakSelf pushToSumFeeController];
        };
        tableView.separatorColor = ClearColor;
        return cell;
    }
    //只有一种日期显示 断网 或 默认
    if (self.usrModel.date_select.count == 1 || self.usrModel.max_money <= 0) {
        YMSingleLoanCell* cell = [YMSingleLoanCell shareCellWithUserModel:self.usrModel ApplyBlock:^(UIButton *btn) {
            [self pushToCertainControllerWithButton:btn];
        }];
        cell.sumBlock = ^(UIButton* sumBtn){
            DDLog(@"点击啦费率");
            [weakSelf pushToSumFeeController];
        };
        return cell;
    }
    //1-2-3-4-5 - 9   -1//待借钱
    LoanApplyCell* cell = [LoanApplyCell shareCellWithUserModel:self.usrModel ApplyBlock:^(UIButton *btn) {
        [self pushToCertainControllerWithButton:btn];
    }];
    cell.sumBlock = ^(UIButton* sumBtn){
        DDLog(@"点击啦费率");
        [weakSelf pushToSumFeeController];
    };
    return cell;
}
-(void)pushToLoanMoneyControllerWithButton:(UIButton* )btn certainClass:(Class)class{
    //登陆
    if ([[YMUserManager shareInstance] isValidLogin]) {
        YMLoanController* lvc = [[YMLoanController alloc]init];
        lvc.title = @"立即借款";
        lvc.hidesBottomBarWhenPushed = YES;
        if ([class class] == [LoanApplyCell class ]) {
            LoanApplyCell* weakCell = (LoanApplyCell*)btn.superview.superview.superview;
            lvc.loanMoney = weakCell.loanMoney;
            
            if (weakCell.loanMoney <= 0) {
                [MBProgressHUD showFail:@"最小借款金额为100元!" view:self.view];
                return;
            }
            //日期
            NSString* dateNum = [weakCell.selectBtn.titleLabel.text substringToIndex:weakCell.selectBtn.titleLabel.text.length - 1];
            lvc.dateNum = dateNum;
          
        }
        if ([class class] == [YMSingleLoanCell class]) {
          YMSingleLoanCell* cell = (YMSingleLoanCell* )btn.superview.superview;
            lvc.loanMoney = cell.loanMoney;
            
            if (cell.loanMoney <= 0) {
                [MBProgressHUD showFail:@"最小借款金额为100元!" view:self.view];
                return;
            }
            //日期
            NSString* dateNum = [cell.dateSelectLabel.text substringToIndex:cell.dateSelectLabel.text.length - 1];
            lvc.dateNum = dateNum;
        }
          [self.navigationController pushViewController:lvc animated:YES];
    }
}
-(void)pushToSumFeeController{
    YMWebViewController* wvc = [[YMWebViewController alloc]init];
    wvc.urlStr = calculatorURL;
    wvc.title = @"费率计算";
    wvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wvc animated:YES];
}
#pragma mark - 网络请求 查询开户信息
-(void)requestAccountInfo {
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    [param setObject:@"all" forKey:@"info_type"];
    //渠道
    [[HttpManger sharedInstance]callHTTPReqAPI:getAccountInfoURL params:param view:self.view loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        
        NSDictionary* resData = responseObject[@"data"];
        NSInteger position = [NSString positionWithDictionary:resData];
        //跳转到相应的开户界面
        [self pushToApplyControllerWithPosition:position];
    }];
}
//跳转到相应的开户界面
-(void)pushToApplyControllerWithPosition:(NSInteger)position{
    switch (position) {
        case 0:
        {
            [self pushToController:[YMIdentityController new] title:@"身份认证" isShowNext:YES isModify:NO];
            DDLog(@"点击回调了开户");
        }
            break;
        case 1:
        {
            //人脸识别
            if (![MGLiveManager getLicense]) {
                [MGLiveManager licenseForNetWokrFinish:^(bool License) {
                    NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"title_license", nil), License ? NSLocalizedString(@"title_success", nil) : NSLocalizedString(@"title_failure", nil)]);
                }];
                return;
            }
            CustomDetectViewController* customDetectVC = [[CustomDetectViewController alloc] initWithDefauleSetting];
            customDetectVC.hidesBottomBarWhenPushed = YES;
            customDetectVC.isShowNext = YES;
            [self.navigationController pushViewController:customDetectVC animated:YES];
            DDLog(@"点击回调了人脸识别");
        }
            break;
        case 2:
        {
            [self pushToController:[YMBankCardController new] title:@"绑定银行储蓄卡" isShowNext:YES isModify:NO];
            DDLog(@"点击回调了绑定银行卡");
        }
            break;
        case 3:
        {
            [self pushToController:[YMAddressController new] title:@"基本信息" isShowNext:YES isModify:NO];
            DDLog(@"点击回调了绑定银行卡");
        }
            break;
        case 4:
        {
            [self pushToController:[YMRelationController new] title:@"紧急联系人" isShowNext:YES isModify:NO];
            DDLog(@"点击回调了紧急联系人");
        }
            break;
        case 5:
        {
            [self pushToController:[YMWebViewController new] title:@"手机认证" isShowNext:YES isModify:NO];
        }
            break;
            
        default:
            break;
    }
}

//跳转到指定控制器
-(void)pushToCertainControllerWithButton:(UIButton* )btn{
    // 1 - 5
    if ([[YMUserManager shareInstance] isValidLogin]) {
        if (self.usrModel.postion.integerValue < 6) {
            //请求账号信息
            [self requestAccountInfo];
        }
    }else{
        [[YMUserManager shareInstance] pushToLoginWithViewController:self];
    }
        switch (self.usrModel.postion.integerValue) {
            case 6:
            {
                [self pushToController:[YMApplyMainController new] title:@"提交资料，立即申请开户" isShowNext:YES isModify:NO];
            }
                break;
                //资料审核不通过 检查（check1 - check5 字段 为0则对应1到5对应步骤不通过，跳到对应步骤编辑资料
            case 77:
            {
                DDLog(@"审核不通过");
                [self pushToController:[YMApplyMainController new] title:@"提交资料，立即申请开户" isShowNext:NO isModify:NO];
            }
                break;
            case 99:
            {
                DDLog(@"立即借款");
                YMLoanController* lvc = [[YMLoanController alloc]init];
                lvc.title = @"立即借款";
                lvc.hidesBottomBarWhenPushed = YES;
                
                LoanApplyCell* weakCell = (LoanApplyCell*)btn.superview.superview;
                lvc.loanMoney = weakCell.loanMoney;
                [self.navigationController pushViewController:lvc animated:YES];
            }
                break;
            default:
                break;
        }
}

//审核不通过 --- 跳转到指定界面
-(void)pushToApplyControllerWithCheckStatus {
    if (self.usrModel.check1.integerValue == 0) {
        [self pushToController:[YMIdentityController new] title:@"身份认证" isShowNext:YES isModify:YES];
    }
    if (self.usrModel.check2.integerValue == 0) {
        [self pushToController:[YMBankCardController new] title:@"绑定银行储蓄卡" isShowNext:YES isModify:YES];
    }
    if (self.usrModel.check3.integerValue == 0) {
        [self pushToController:[YMAddressController new] title:@"基本信息" isShowNext:YES isModify:YES];
    }
    if (self.usrModel.check4.integerValue == 0) {
        [self pushToController:[YMRelationController new] title:@"紧急联系人" isShowNext:YES isModify:YES];
    }
    if (self.usrModel.check5.integerValue == 0) {
        [self pushToController:[YMVideoInfoController new] title:@"影像资料" isShowNext:YES isModify:YES];
    }
}

//审核被拒情况
-(NSString* )getCheckStepWithUsrModel{
    if (self.usrModel.check1.integerValue == 2) {
        return @"1";
    }
    if (self.usrModel.check2.integerValue == 2) {
        return @"2";
    }
    if (self.usrModel.check3.integerValue == 2) {
        return @"3";
    }
    if (self.usrModel.check4.integerValue == 2) {
        return @"4";
    }
    if (self.usrModel.check5.integerValue == 2) {
        return @"5";
    }else{
        return @"0";
    }
}

//跳转到指定界面
-(void)pushToController:(UIViewController* )controller title:(NSString* )title isShowNext:(BOOL)isShowNext isModify:(BOOL)isModify{
    controller.title = title;
    if ([controller isKindOfClass:[YMAddressController class]]) {
        YMAddressController *cvc = (YMAddressController* )controller ;
        cvc.isShowNext = isShowNext;
        cvc.isModify = isModify;
        controller = cvc;
    }
    if ([controller isKindOfClass:[YMIdentityController class]]) {
        YMIdentityController *cvc = (YMIdentityController* )controller ;
        cvc.isShowNext = isShowNext;
         cvc.isModify = isModify;
        controller = cvc;
    }
    if ([controller isKindOfClass:[YMRelationController class]]) {
        YMRelationController *cvc = (YMRelationController* )controller;
        cvc.isShowNext = isShowNext;
         cvc.isModify = isModify;
        controller = cvc;
    }
    if ([controller isKindOfClass:[YMVideoInfoController class]]) {
        YMVideoInfoController *cvc = (YMVideoInfoController* )controller ;
        cvc.isShowNext = isShowNext;
         cvc.isModify = isModify;
        controller = cvc;
    }
    if ([controller isKindOfClass:[YMBankCardController class]]) {
        YMBankCardController *cvc = (YMBankCardController* )controller ;
        cvc.isShowNext = isShowNext;
         cvc.isModify = isModify;
        controller = cvc;
    }
    //审核被拒
    if ([controller isKindOfClass:[YMApplyMainController class]]) {
        YMApplyMainController *cvc = (YMApplyMainController* )controller ;
        cvc.isNext = isShowNext;
        cvc.checkStep = [self getCheckStepWithUsrModel];
        controller = cvc;
    }
    //手机认证
    if ([controller isKindOfClass:[YMWebViewController class]]) {
        YMWebViewController *cvc = (YMWebViewController* )controller ;
        cvc.isNext = isShowNext;
        cvc.urlStr = getMobileURL;
        cvc.isSecret = YES;
        cvc.title = @"手机认证";
        cvc.isNext = YES;
        controller = cvc;
    }
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - 立即还款
-(void)requestBackMoney {
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    //网络
    [param setObject: [YMTool getNetWorkStates] forKey:@"network"];
    //手机型号
    if ([YMTool deviceModel]) {
        //手机型号
        [param setObject:[YMTool deviceModel] forKey:@"mobile_brand"];
    }else{
        [param setObject:[YMTool deviceModel] forKey:@"iphone"];
    }

    [[HttpManger sharedInstance]callHTTPReqAPI:backMoneyURL params:param view:self.view isEdit:YES loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        
        [MBProgressHUD showSuccess:responseObject[@"msg"] view:self.view];
        NSNumber* code = responseObject[@"code"];
        if (code.integerValue == 200) {
            //还款成功之后，将借款成功设置为NO
            [kUserDefaults setBool:NO forKey:kisSuccessLoan];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self requestUserStatusInfoWithIsLoading:YES];
            });
        }
        if (code.integerValue == 500) {
            //还款成功之后，将借款成功设置为NO
            [kUserDefaults setBool:NO forKey:kisFailureBackLoan];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self requestUserStatusInfoWithIsLoading:YES];
            });
        }
  
    }];
}

@end
