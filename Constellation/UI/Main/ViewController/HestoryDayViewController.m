//
//  HestoryDayViewController.m
//  Constellation
//
//  Created by Sj03 on 2018/4/8.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "HestoryDayViewController.h"
#import "HestoryDayTableViewCell.h"
#import "PostWebViewController.h"

@interface HestoryDayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HestoryDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavWithTitle:@"历史上的今天" leftImage:@"Whiteback" rightImage:nil superView:nil];
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.theSimpleNavigationBar.bottomLineView.hidden = YES;
    self.theSimpleNavigationBar.backgroundColor =UIColorFromRGB(0x5d2ebe);
    
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HestoryDayTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HestoryDayTableViewCell class])];
    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HestoryDayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HestoryDayTableViewCell class]) forIndexPath:indexPath];
    [cell getDateForServer:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PostWebViewController *webView = [[PostWebViewController alloc] init];
    NSDictionary *dic =self.dataArray[indexPath.row];
    webView.titleStr = [dic stringForKey:@"title"];
    webView.urlStr = @"https://yz.m.sm.cn/s";
    [self.navigationController pushViewController:webView animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
