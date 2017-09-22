//
//  YMMsgDetailController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMsgDetailController.h"
#import "YMMsgDetailCell.h"
#import "UIBarButtonItem+HKExtension.h"

@interface YMMsgDetailController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YMMsgDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    //修改view
    [self modifyView];
    //请求消息详情
    [self requestMessageDetail];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)modifyView{
    self.tableView.tableFooterView = [UIView new];
    
    UIButton *backButton = [Factory createNavBarButtonWithImageStr:@"back" target:self selector:@selector(back)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
-(void)back{
    DDLog(@"返回按钮执行了");
    if (self.refreshBlock) {
        self.refreshBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)deleteMsgClick:(UIButton* )btn{
    DDLog(@"删除了按钮");
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:_model.type forKey:@"type_message"];
    //消息id
    [param setObject:_model.id forKey:@"id_message"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];//
    [[HttpManger sharedInstance]callHTTPReqAPI:MessageDeleteURL params:param view:self.view  loading:YES tableView:self.tableView  completionHandler:^(id task, id responseObject, NSError *error) {
        //刷新
        if (self.refreshBlock) {
             self.refreshBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - requestNetWork
-(void)requestMessageDetail {
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:_model.type forKey:@"type_message"];//
    [param setObject:_model.id forKey:@"id_message"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];//

    NSString* urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@&type_message=%@&id_message=%@",MessageDetailURL,
                        [kUserDefaults valueForKey:kUid],
                        [kUserDefaults valueForKey:kToken],
                        _model.type,
                        _model.id];
    YMWeakSelf;
    [[HttpManger sharedInstance] getHTTPReqAPI:urlStr params:param view:self.view isEdit:YES  loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        
        weakSelf.model = [YMMsgModel mj_objectWithKeyValues:responseObject[@"data"]];
        [weakSelf.tableView reloadData];
    }];
}

//-(void)readMessageRequest{
//    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
//    [param setObject:_model.type forKey:@"type_message"];
//    [param setObject:_model.id forKey:@"id_message"];
//    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
//    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];//
//
//    [[HttpManger sharedInstance] callHTTPReqAPI:MessageReadURL params:param view:self.view loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
//
//    }];
//}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YMMsgDetailCell * cell = [YMMsgDetailCell shareCell];
    cell.model = self.model;
    cell.selectionStyle           = UITableViewCellSelectionStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

//#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

#pragma mark - text height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60 + self.model.textHeight;
}

@end
