//
//  YMProtocalListController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/9.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMProtocalListController.h"
#import "SectionHeadCell.h"
#import "YMWebViewController.h"

@interface YMProtocalListController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//数据
@property(nonatomic,strong)NSMutableArray* dataArr;

@end

@implementation YMProtocalListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"个人信用贷款合同",@"人行征信授权协议",@"贷吧标准化服务协议"].mutableCopy;
    }
    return _dataArr;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    SectionHeadCell* cell = [SectionHeadCell shareCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titlLabel.text = self.dataArr[indexPath.row];
    cell.detailLabel.text = @"";
    if (indexPath.row == self.dataArr.count - 1) {
        //去掉分割线
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YMWebViewController* yvc = [[YMWebViewController alloc]init];
    switch (indexPath.row) {
        case 0:
         yvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&token=%@&order_id=%@&channel_key=hjr_app",loansPactProtocolURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken],self.orderModel.id];
            break;
        case 1:
            yvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&token=%@&channel_key=hjr_app",creditAccreditURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
            //creditAccreditURL;
             break;
        case 2:
             yvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&token=%@&order_id=%@&channel_key=hjr_app",serveProtocolURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken],self.orderModel.id];
            break;
        default:
            break;
    }
    yvc.title = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:yvc animated:YES];
    
}
@end
