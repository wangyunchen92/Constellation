//
//  YMSafeSetController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/5.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMSafeSetController.h"
#import "YMModifyPasswdController.h"
#import "YMSetLoginPswdController.h"
#import "YMPaySecrectController.h"
#import "YMForgetViewController.h"
#import "YMModifySecrectPsController.h"
#import "SectionHeadCell.h"



@interface YMSafeSetController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray* titleArr;

@property(nonatomic,strong)NSNumber* isSetPayPassword;
@end

@implementation YMSafeSetController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = BackGroundColor;
    [self requestLoanUseData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"修改登陆密码",@"修改借款密码"].mutableCopy;
    }
    return _titleArr;
}
//获取借款用途
-(void)requestLoanUseData {
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    
    [[HttpManger sharedInstance]callHTTPReqAPI:getBorrowConfigURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        // 是否设置了支付密码
        self.isSetPayPassword = responseObject[@"data"][@"is_set"];
        
        //刷新界面
        [self.tableView reloadData];
    }];
}
#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionHeadCell* cell = [SectionHeadCell shareCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titlLabel.text = self.titleArr[indexPath.row];
    cell.detailLabel.text = @"";

    if (indexPath.row == self.titleArr.count - 1) {
        cell.titlLabel.text = self.isSetPayPassword.integerValue ? @"修改借款密码" : @"设置借款密码";
        //去掉分割线
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YMForgetViewController* yvc = [[YMForgetViewController alloc]init];
        yvc.passwordType = PasswordTypeModify;
        yvc.title = @"修改密码";
        [self.navigationController pushViewController:yvc animated:YES];

    }else{
       if (self.isSetPayPassword.integerValue == 0) {
            YMWeakSelf;
            YMPaySecrectController * yvc = [[YMPaySecrectController alloc]init];
            yvc.title = @"设置借款密码";
           
            yvc.refreshStateBlock = ^(BOOL isSet, NSString *password) {
                SectionHeadCell* cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                cell.titlLabel.text = @"修改借款密码";
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:yvc animated:YES];
        }else{
            YMModifySecrectPsController* yvc = [[YMModifySecrectPsController alloc]init];
            yvc.title =  @"修改借款密码" ;
            [self.navigationController pushViewController:yvc animated:YES];
        }
    }
}

@end
