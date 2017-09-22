//
//  YMLoanProtocalController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/11.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMLoanProtocalController.h"
#import "ExtendButton.h"



@interface YMLoanProtocalController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ExtendButton *closeBtn;

@property(nonatomic,strong)NSMutableArray* titlesArr;


@end

@implementation YMLoanProtocalController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加灰色背景
    self.view.frame = CGRectMake(0, SCREEN_HEGIHT - ((self.titlesArr.count) * 50 + 40) - 40  , SCREEN_WIDTH,  (self.titlesArr.count) * 50 + 40);
    
    // 添加灰色背景
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.3;
    
    self.backgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEGIHT - self.view.height - 40);
    self.backgroundView.hidden = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideProtocalView:)];
    [self.backgroundView addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
}
-(NSMutableArray *)titlesArr{
    if (!_titlesArr) {
        _titlesArr = @[@"个人信用报告查询授权书",@"贷吧标准化服务协议"].mutableCopy;
    }
    return  _titlesArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMWeakSelf;
    SectionHeadCell* cell = [SectionHeadCell shareCellWithTapBlock:^(SectionHeadCell *cell) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock(cell);
        }
        [weakSelf hideProtocalView:nil];
    }];
    cell.titlLabel.text = self.titlesArr[indexPath.row];
    cell.detailLabel.text = @"";
   

    cell.selected = NO;
    cell.tag = indexPath.row;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == self.titlesArr.count - 1) {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
    }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//#pragma mark - UITableViewDelegate
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    YMWeakSelf;
//    SectionHeadCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (cell.selected == NO) {
//         cell.selected = YES;
//    }
//    DDLog(@"cell select == %d",cell.selected);
//    cell.tapBlock = ^(SectionHeadCell *cell) {
//        if (weakSelf.tapBlock) {
//             weakSelf.tapBlock(cell);
//        }
//        [weakSelf hideProtocalView:nil];
//    };
//
//}
- (IBAction)closeBtnClick:(id)sender {
    [self hideProtocalView:nil];
}
-(void)hideProtocalView:(UITapGestureRecognizer* )tap{
    DDLog(@"隐藏backgroundView");
    self.backgroundView.hidden = YES;
    self.view.hidden = YES;
}
@end
