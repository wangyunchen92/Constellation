//
//  YMBankCardListController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/11.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMBankCardListController.h"
#import "YMBankCardCell.h"
#import "UIView+Placeholder.h"



@interface YMBankCardListController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)BankModel*  bankModel;

@property(nonatomic,strong)NSMutableArray* dataArr;
//占位页面
@property(nonatomic,strong)UIView* placeView;

@end

@implementation YMBankCardListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];

    [self requestAccountInfo];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(UIView *)placeView{
    if (!_placeView) {
        _placeView = [UIView placeViewWhithFrame:self.tableView.frame placeImgStr:@"iconPlaceholder" placeString:@"您暂时还没有绑定银行卡！"];
        [self.view addSubview:_placeView];
        _placeView.hidden = YES;
    }
    return _placeView;
}

#pragma mark - 网络请求
-(void)requestAccountInfo {
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    [param setObject:@"bank" forKey:@"info_type"];
    [[HttpManger sharedInstance]callHTTPReqAPI:getAccountInfoURL params:param view:self.view loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
 
        weakSelf.bankModel = [BankModel mj_objectWithKeyValues:responseObject[@"data"][@"bank"]];
        if (![NSString isEmptyString:weakSelf.bankModel.bank_account]) {
              [weakSelf.dataArr addObject:weakSelf.bankModel];
        }
        weakSelf.placeView.hidden = weakSelf.dataArr.count;
        [weakSelf.tableView reloadData];
    }];
    
}
#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = BackGroundColor;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMBankCardCell* cell = [YMBankCardCell shareCellWithModifyBlock:^(UIButton *btn) {
     
    }];
    cell.backgroundColor = BackGroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bankModel = self.dataArr[indexPath.row];
    cell.modifyBtn.hidden = YES;
    cell.lineView.hidden  = YES;
    return cell;
}
@end
