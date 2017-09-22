//
//  WaitController.m
//  Daiba
//
//  Created by YouMeng on 2017/7/26.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWaitController.h"
#import "YMCreditCollectionCell.h"
#import "YMCreditModel.h"
#import "YMWebViewController.h"

@interface YMWaitController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//集合
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

//数据源
@property(nonatomic,strong)NSMutableArray* dataArr;
@property(nonatomic,strong)NSMutableArray* titlesArr;

//信用模型
@property(nonatomic,strong)YMCreditModel* creditModel;
@end

@implementation YMWaitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YMTool addTapGestureOnView:_imgView target:self selector:@selector(pushLogin) viewController:self];
  
    [self.collectionView registerNib:[UINib nibWithNibName:@"YMCreditCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"YMCreditCollectionCell"];
    
     //获取认证信息
//    if ([[YMUserManager shareInstance] isValidLogin]) {
//        [self requestCreditList];
//    }
}
-(void)pushLogin{
    if ([[YMUserManager shareInstance]isValidLogin] == NO) {
        [[YMUserManager shareInstance]pushToLoginWithViewController:self isShowAlert:NO];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSMutableArray *)titlesArr{
    if (!_titlesArr) {
        _titlesArr = @[@"手机认证",@"芝麻信用认证",@"学位认证",@"绑定社保账号",@"绑定公积金账号",@"淘宝认证",@"京东认证"].mutableCopy;
        
    }
    return _titlesArr;
}


-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"手机认证",@"芝麻信用",@"学位认证",@"社保",@"公积金",@"淘宝",@"京东"].mutableCopy;
    }
    return _dataArr;
}

#pragma mark - 网络请求
//请求个人信用信息
-(void)requestCreditList {
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:kUid];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:kToken];
    [[HttpManger sharedInstance]callHTTPReqAPI:getCreditListURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
        self.creditModel = [YMCreditModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self.collectionView reloadData];
    }];
    
}
//请求芝麻信用 授权
-(void)requestZmxyAuthWithCreditCollectionCell:(YMCreditCollectionCell* )cell {
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:kUid];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:kToken];
    [[HttpManger sharedInstance]callHTTPReqAPI:getZmxyAuthURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
        YMWebViewController* wvc = [[YMWebViewController alloc]init];
        wvc.urlStr = responseObject[@"data"];
        wvc.agreeBlock = ^(NSString *isAgree) {
//            cell.titleLabel.text = @"芝麻信用已授权";
            [self requestCreditList];
        };
        wvc.title = @"芝麻信用授权";
        wvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wvc animated:YES];
    }];
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YMCreditCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YMCreditCollectionCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [YMCreditCollectionCell shareCell];
    }
    cell.titleLabel.text = self.titlesArr[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:self.dataArr[indexPath.row]];
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_WIDTH == 320) {
         return (CGSize){80,120};
    }
    if (SCREEN_WIDTH == 414) {
        return (CGSize){100,140};
    }
     else {
        return (CGSize){90,130};
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return (CGSize){SCREEN_WIDTH,44};
//}

//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return (CGSize){SCREEN_WIDTH,22};
//}

#pragma mark ---- UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //开始请求芝麻信用授权
        YMCreditCollectionCell* cell = (YMCreditCollectionCell*)collectionView;
        [self requestZmxyAuthWithCreditCollectionCell:cell];

    }
}
// 长按某item，弹出copy和paste的菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 使copy和paste有效
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"] || [NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        return YES;
    }
    return NO;
}
//
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    if([NSStringFromSelector(action) isEqualToString:@"copy:"])
    {
        //        NSLog(@"-------------执行拷贝-------------");
        [_collectionView performBatchUpdates:^{
           // [_section0Array removeObjectAtIndex:indexPath.row];
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    }
    else if([NSStringFromSelector(action) isEqualToString:@"paste:"])
    {
        NSLog(@"-------------执行粘贴-------------");
    }
}

@end
