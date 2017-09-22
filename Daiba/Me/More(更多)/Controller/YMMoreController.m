//
//  YMMoreController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/9.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMoreController.h"
#import "YMAboutController.h"
#import "YMWebViewController.h"
#import "SectionHeadCell.h"

@interface YMMoreController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray* dataArr;
@end

@implementation YMMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = BackGroundColor;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"关于贷吧",@"意见反馈",@"免责声明",@"去好评"].mutableCopy;
    }
    return _dataArr;
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SectionHeadCell* cell = [SectionHeadCell shareCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titlLabel.text = self.dataArr[indexPath.row];
    cell.detailLabel.text = @"";
    if (indexPath.row == 1 || indexPath.row == 3) {
        cell.detailLabel.text = @"敬请期待";
    }
    if (indexPath.row == self.dataArr.count - 1) {
        //去掉分割线
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YMAboutController* yvc = [[YMAboutController alloc]init];
        yvc.title = @"关于贷吧";
        [self.navigationController pushViewController:yvc animated:YES];
    }
    if (indexPath.row == 2) {
        YMWebViewController * yvc = [[YMWebViewController alloc]init];
        yvc.title = @"注册协议";
        yvc.urlStr = RegistProtocalURL;
        [self.navigationController pushViewController:yvc animated:YES];
    }
    
}

@end
