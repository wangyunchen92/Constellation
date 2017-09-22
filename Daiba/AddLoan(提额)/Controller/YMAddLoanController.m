//
//  YMAddLoanController.m
//  Daiba
//
//  Created by YouMeng on 2017/7/31.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMAddLoanController.h"
#import "QuotaCell.h"
#import "YMTitleCell.h"
#import "YMHeightTools.h"
#import "YMLoanTieCell.h"
#import "YMCreditModel.h"
#import "YMWebViewController.h"
#import "UIImage+Extension.h"


@interface YMAddLoanController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//
@property(nonatomic,strong)NSMutableArray* titlesArr;
@property(nonatomic,strong)NSMutableArray* iconsArr;

@property(nonatomic,strong)YMCreditModel* creditModel;

//数据
@property(nonatomic,strong)NSMutableArray* dataArr;
@end

@implementation YMAddLoanController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = BackGroundColor;
    self.tableView.backgroundColor = BackGroundColor;

//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestCreditListWithLoading:)];
//   
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
//    header.mj_h = 50;
//    
//     [header setImages:[UIImage imagesArrByGifImageStr:@"gif"] forState:MJRefreshStateIdle];
//    [header setImages:[UIImage imagesArrByGifImageStr:@"gif"] forState:MJRefreshStatePulling];
//    // [header setImages:[UIImage imagesArrByGifImageStr:@"gif"] forState:MJRefreshStateRefreshing];
//    [header setImages:[UIImage imagesArrByGifImageStr:@"gif"] duration:2 forState:MJRefreshStateRefreshing];
//    self.tableView.mj_header = header;
    
     self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
          [self requestCreditListWithLoading:NO];
     }];
  
    [self requestCreditListWithLoading:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userStatusChanged:) name:kNotification_LoginStatusChanged object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotification_LoginStatusChanged object:nil];
    
}
-(void)userStatusChanged:(NSNotification* )notif{
    [self requestCreditListWithLoading:YES];
}
//请求个人信用信息
-(void)requestCreditListWithLoading:(BOOL)isLoading{
    if ([[YMUserManager shareInstance] isValidLogin] == NO) {
         [self.tableView.mj_header endRefreshing];
        YMLoginController* lvc = [[YMLoginController alloc]init];
        YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:kUid];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:kToken];
    [[HttpManger sharedInstance]callHTTPReqAPI:getCreditListURL params:param view:self.view loading:isLoading tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        self.creditModel = [YMCreditModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self.dataArr addObject:responseObject[@"data"][@"mobile_credit"]];
        [self.dataArr addObject:responseObject[@"data"][@"zmxy"]];
        [self.dataArr addObject:responseObject[@"data"][@"xxrz"]];
        [self.dataArr addObject:responseObject[@"data"][@"sbzh"]];
        [self.dataArr addObject:responseObject[@"data"][@"gjj"]];
        [self.dataArr addObject:responseObject[@"data"][@"tb"]];
        [self.dataArr addObject:responseObject[@"data"][@"jd"]];
        
        [self.tableView reloadData];
    }];
}

//请求芝麻信用 授权
-(void)requestZmxyAuth{
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:kUid];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:kToken];
    [[HttpManger sharedInstance]callHTTPReqAPI:getZmxyAuthURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
        YMWebViewController* wvc = [[YMWebViewController alloc]init];
        wvc.urlStr = responseObject[@"data"];
        wvc.agreeBlock = ^(NSString *isAgree) {
           // cell.titleLabel.text = @"芝麻信用已授权";
            [self requestCreditListWithLoading:YES];
        };
        wvc.title = @"芝麻信用授权";
        wvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wvc animated:YES];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSMutableArray *)titlesArr{
    if (!_titlesArr) {
        _titlesArr = @[@"手机认证",@"芝麻信用认证",@"学位认证",@"绑定社保账号",@"绑定公积金账号",@"淘宝认证",@"京东认证"].mutableCopy;
    }
    return _titlesArr;
}
-(NSMutableArray *)iconsArr{
    if (!_iconsArr) {
        _iconsArr =
        @[@"手机认证",@"芝麻信用",@"学位认证",@"社保",@"公积金",@"淘宝",@"京东"].mutableCopy;
    }
    return _iconsArr;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titlesArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (SCREEN_WIDTH == 320) {
        return 74 - 20;
    }
    if (SCREEN_WIDTH == 375) {
        return 74 - 16;
    }
    return 74;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YMLoanTieCell* cell = [YMLoanTieCell shareCellWithTableView:tableView];
    cell.titlLabel.text = self.titlesArr[indexPath.section];
    cell.iconView.image = [UIImage imageNamed:self.iconsArr[indexPath.section]];

    [cell cellWithCreditModel:self.creditModel indexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = BackGroundColor;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[YMUserManager shareInstance]isValidLogin] == NO) {
        YMLoginController* lvc = [[YMLoginController alloc]init];
        YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
        lvc.refreshWebBlock = ^{
            //刷新界面
            [self requestCreditListWithLoading:YES];
        };
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    if (indexPath.section == 1) {
        if (self.creditModel.zmxy.integerValue == 1) {
            [MBProgressHUD showSuccess:@"您的芝麻信用已认证！" view:self.view];
            return;
        }
        [self requestZmxyAuth];
    }
    if (indexPath.section == 0) {
        if (self.creditModel.mobile_credit.integerValue == 1) {
            [MBProgressHUD showSuccess:@"您的手机已认证！" view:self.view];
            return;
        }
        if ([[kUserDefaults valueForKey:kPostion] integerValue] != 99) {
            //手机认证
            [MBProgressHUD showSuccess:@"请先开户！" view:self.view];
            return;
        }
        DDLog(@"手机认证");
        YMWebViewController* wvc = [[YMWebViewController alloc]init];
        wvc.urlStr = getMobileURL;
        wvc.agreeBlock = ^(NSString *isAgree) {
            
            NSTimeInterval nowTime = [[NSDate date]timeIntervalSince1970];
            NSTimeInterval setPhoneTime = nowTime + 5 * 60;
            
            [kUserDefaults setObject: @(setPhoneTime)  forKey:kSetPhoneDate];
            [kUserDefaults synchronize];
            
            [self requestCreditListWithLoading:YES];
        };
        wvc.title = @"手机认证";
        wvc.hidesBottomBarWhenPushed = YES;
        wvc.isSecret = YES;
        [self.navigationController pushViewController:wvc animated:YES];
    }
}

#pragma MoxieSDK Result Delegate
-(void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary{
    int code = [resultDictionary[@"code"] intValue];
    NSString *taskType = resultDictionary[@"taskType"];
    NSString *taskId = resultDictionary[@"taskId"];
    NSString *searchId = resultDictionary[@"searchId"];
    NSString *message = resultDictionary[@"message"];
    NSString *account = resultDictionary[@"account"];
    NSLog(@"get import result---code:%d,taskType:%@,taskId:%@,searchId:%@,message:%@,account:%@",code,taskType,taskId,searchId,message,account);
    //用户没有做任何操作
    if(code == -1){
        DDLog(@"用户未进行操作");
    }
    //假如code是2则继续查询该任务进展
    else if(code == 2){
        DDLog(@"任务进行中，可以继续轮询");
    }
    //假如code是1则成功
    else if(code == 1){
        DDLog(@"任务成功");
    }
    //该任务失败按失败处理
    else{
        DDLog(@"任务失败");
    }
    NSTimeInterval nowTime = [[NSDate date]timeIntervalSince1970];
    NSTimeInterval setPhoneTime = nowTime + 5 * 60;
    
    [kUserDefaults setObject: @(setPhoneTime)  forKey:kSetPhoneDate];
    [kUserDefaults synchronize];
    
    [self.tableView reloadData];
    DDLog(@"任务结束，可以根据taskid，在租户管理系统查询该次任何的最终数据，在魔蝎云监控平台查询该任务的整体流程信息。SDK只会回调状态码及部分基本信息，完整数据会最终通过服务端回调。（记得将本demo的apikey修改成公司对应的正确的apikey）");
}

@end
