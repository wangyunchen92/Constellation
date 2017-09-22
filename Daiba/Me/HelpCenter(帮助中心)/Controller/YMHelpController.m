//
//  YMHelpController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/9.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMHelpController.h"
#import "YMHelpModel.h"
#import "YMHelpDetailController.h"



@interface YMHelpController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = BackGroundColor;
    
}
-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = [YMHelpModel mj_objectArrayWithKeyValuesArray:dataArr];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    YMHelpModel* model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  //cell.separatorInset = UIEdgeInsetsMake(0,-SCREEN_WIDTH, 0, 0);
  //cell.layoutMargins  = UIEdgeInsetsZero;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YMHelpDetailController* wvc = [[YMHelpDetailController alloc]init];
    YMHelpModel* model = self.dataArr[indexPath.row];
    wvc.typeId = model.id;
    wvc.model  = model;
    [self.navigationController pushViewController:wvc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     *以下代码兼容IOS6-8
     *IOS7仅需要设置separatorInset为UIEdgeInsetsZero就可以让分割线顶头了
     *而IOS8需要将separatorInset设置为UIEdgeInsetsZero并且还需要将tabelView和tabelViewCell的layoutMargins设置为UIEdgeInsetsZero
     */
    //setSeparatorInset IOS7之后才支持
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    //setLayoutMargins IOS8之后才支持
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
