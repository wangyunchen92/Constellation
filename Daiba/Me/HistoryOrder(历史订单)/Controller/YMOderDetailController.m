//
//  YMOderDetailController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/8.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMOderDetailController.h"
#import "YMOrderDetailCell.h"
#import "YMProtocalListController.h"

@interface YMOderDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMOderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMWeakSelf;
    YMOrderDetailCell* cell = [YMOrderDetailCell shareCellWithContactBlock:^{
        DDLog(@"跳转合同");
        YMProtocalListController* yvc = [[YMProtocalListController alloc]init];
        yvc.title = @"贷款相关协议";
        yvc.orderModel = weakSelf.orderModel;
        [weakSelf.navigationController pushViewController:yvc animated:YES];
    }];
    cell.orderModel = self.orderModel;
    //去掉分割线
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);

    return cell;
}


@end
