//
//  YMHistoryListController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/8.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMHistoryListController.h"
#import "YMOrderStatusCell.h"
#import "YMOrderModel.h"
#import "YMOderDetailController.h"
#import "UIView+Placeholder.h"


@interface YMHistoryListController ()<UITableViewDataSource,UITableViewDelegate>

// 标
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray* dataArr;

@property(nonatomic,strong)UIView* placeView;
@end

@implementation YMHistoryListController

- (void)viewDidLoad {
    [super viewDidLoad];
     //请求数据
    [self requestOrderData];
    
    self.tableView.tableFooterView = [UIView new];
    
}
-(UIView *)placeView{
    if (!_placeView) {
        _placeView = [UIView placeViewWhithFrame:self.tableView.frame placeImgStr:@"iconPlaceholder" placeString:@"您暂时还没有账单信息！"];
        [self.view addSubview:_placeView];
        _placeView.hidden = YES;
    }
    return _placeView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 请求数据
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMOrderStatusCell*  cell = [YMOrderStatusCell shareCell];
    cell.model = self.dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == self.dataArr.count - 1) {
        //去掉分割线
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);

    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YMOderDetailController* yvc = [[YMOderDetailController alloc]init];
    yvc.title = @"订单详情";
    yvc.orderModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:yvc animated:YES];
}

#pragma mark - 网络数据请求
-(void)requestOrderData{
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    [[HttpManger sharedInstance]callHTTPReqAPI:HistoryListURL params:param view:self.view loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        
        weakSelf.dataArr = [YMOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        weakSelf.placeView.hidden = weakSelf.dataArr.count;
        
        [weakSelf.tableView reloadData];
    }];
}
@end
