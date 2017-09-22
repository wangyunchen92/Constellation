//
//  YMMsgListController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.

#import "YMMsgListController.h"
#import "YMMsgCell.h"
#import "YMMsgDetailController.h"
#import "UIBarButtonItem+HKExtension.h"
#import "YMBottomView.h"
#import "UIControl+Custom.h"
#import "UIView+Placeholder.h"
#import "YMTabBarController.h"


@interface YMMsgListController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray* dataArr;

//选择的数组
@property(nonatomic,strong)NSMutableArray* selectArr;

@property(nonatomic,strong)YMBottomView* btmView;

//页数
@property(nonatomic,assign)NSInteger page;

//占位页面
@property(nonatomic,strong)UIView* placeView;
@end

@implementation YMMsgListController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置按钮
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageNamed:@"del" target:self action:@selector(deleteMsgClick:)];
    //设置底部View
    [self creatBottomView];
    //修改view
    [self modifyView];
    
    //设置返回键
    if (self.isMsgPushed == YES) {
        //设置返回按钮
        [self setLeftBackButton];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//设置返回按钮
-(void)setLeftBackButton{
    UIButton *backButton = [Factory createNavBarButtonWithImageStr:@"back" target:self selector:@selector(back)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.view.backgroundColor = BackGroundColor;
}
-(void)back{
    DDLog(@"设置返回按钮");
    if (self.isMsgPushed ) {
        //未读消息个数
        if (self.refreshBlock) {
            self.refreshBlock(@"0");
            [self.navigationController popViewControllerAnimated:YES];
        }else{
          [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - View
//添加底部的 删除 View
-(void)creatBottomView{
    YMWeakSelf;
    self.btmView = [[YMBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEGIHT - NavBarTotalHeight, SCREEN_WIDTH, 40) titlesArr:@[@"全选",@"删除"] bgColorsHexStrArr:@[@"ffffff",@"ffffff"] textColor:BlackColor selectColor:NavBarTintColor taskBlock:^(UIButton *btn) {
        DDLog(@"点击啦按钮。tag == %ld btn select == %d",(long)btn.tag,btn.selected);
        btn.custom_acceptEventInterval = 1;
        
        if (btn.tag == 0) {//全选
            btn.selected = !btn.selected;
            [weakSelf.selectArr removeAllObjects];
            for (int i = 0 ; i < weakSelf.dataArr.count; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                if (btn.selected == YES) {
                    DDLog(@"selet == %@",weakSelf.selectArr);
                    weakSelf.selectArr = [weakSelf.dataArr mutableCopy];
                    [weakSelf.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
                }else{
                    DDLog(@"selet == %@",weakSelf.selectArr);
                    [weakSelf.selectArr removeAllObjects];
                    [weakSelf.tableView deselectRowAtIndexPath:indexPath  animated:NO];
                }
            }
            DDLog(@"select == %@",weakSelf.selectArr);
        }else{
            DDLog(@"selet == %@",weakSelf.selectArr);
            btn.selected = YES;
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.btmView.y = SCREEN_HEGIHT - NavBarTotalHeight;
            }];
            //删除消息
            [weakSelf deleteMessageWithSelectArr:weakSelf.selectArr];
        }
    }];
    [self.view addSubview:self.btmView];
}
-(void)deleteMessageWithSelectArr:(NSMutableArray* )selectArr{
    DDLog(@"删除了按钮");
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    NSMutableString* idsStr = [[NSMutableString alloc]init] ;
    for (int i = 0 ; i < selectArr.count; i ++) {
        YMMsgModel* model = selectArr[i];
        if (i < selectArr.count - 1) {
            idsStr = [[idsStr stringByAppendingString:[NSString stringWithFormat:@"%@,",model.id]] mutableCopy];
        }else{
             idsStr = [[idsStr stringByAppendingString:[NSString stringWithFormat:@"%@",model.id]] mutableCopy];
        }
    }
    [param setObject:@"1" forKey:@"type_message"];
    //消息id
    [param setObject:idsStr forKey:@"id_message"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];//
    [[HttpManger sharedInstance]callHTTPReqAPI:MessageDeleteURL params:param view:self.view  loading:YES tableView:self.tableView  completionHandler:^(id task, id responseObject, NSError *error) {
        //删除
        [weakSelf.dataArr removeObjectsInArray:weakSelf.selectArr];
        weakSelf.tableView.editing = NO;
        
        weakSelf.placeView.hidden = weakSelf.dataArr.count;
        [weakSelf.tableView reloadData];
    }];
}

//修改view
-(void)modifyView{
    YMWeakSelf;
    //刷新header
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_dataArr removeAllObjects];
        _page = 1;
        //消息列表数据
        [self requestMsgListDataWithPage:1];
    }];
    //底部footer
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ((_page ) * 15 > weakSelf.dataArr.count ) {
            [MBProgressHUD showFail:@"已经是最后一页啦！" view:self.view];
            [weakSelf.tableView.mj_footer endRefreshing];
            return ;
        }
        ++ _page;
        DDLog(@"page = %ld",(long)_page);
        [weakSelf requestMsgListDataWithPage:_page];
    }];
    //开始刷新数据
    [self.tableView.mj_header beginRefreshing];
}

-(void)deleteMsgClick:(UIButton* )btn{
    DDLog(@"删除了按钮  btn == %d",btn.selected);
    if (_dataArr.count == 0) {
        [MBProgressHUD showFail:@"已没有消息可删除啦！" view:self.view];
        return;
    }
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    btn.selected = self.tableView.editing;
    YMWeakSelf;
    if (btn.selected) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.btmView.y = SCREEN_HEGIHT - NavBarTotalHeight - 40;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.btmView.y = SCREEN_HEGIHT - NavBarTotalHeight;
        }];
    }
}
#pragma mark - requestNetWork  网络数据 - 消息中心
-(void)requestMsgListDataWithPage:(NSInteger)page{
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
     [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
     [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
     [param setObject:@"1" forKey:@"type_message"];
     [param setObject:@(page).stringValue forKey:@"page"];
    
    NSString* urlStr = MessageListURL;
    if (page > 0) {
        urlStr = [NSString stringWithFormat:@"%@?page=%d&uid=%@&ssotoken=%@&type_message=%@",
                  urlStr,
                  (long)page,
                  [kUserDefaults valueForKey:kUid],
                  [kUserDefaults valueForKey:kToken],
                  @"1"
                   ];
    }
    [[HttpManger sharedInstance]getHTTPReqAPI:urlStr params:param view:self.view isEdit:YES  loading:YES  tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        if (_page > 1 ) {
            if (responseObject[@"data"] == 0) {
                [MBProgressHUD showFail:@"已经是最后一页啦！" view:self.view];
            }
            NSMutableArray* allTmpArr = [[NSMutableArray alloc]init];
            NSMutableArray* tmpArr    = [YMMsgModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [allTmpArr addObjectsFromArray:_dataArr];
            [allTmpArr addObjectsFromArray:tmpArr];
            _dataArr = allTmpArr;
        }else{
            weakSelf.dataArr  = [YMMsgModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        }
        weakSelf.placeView.hidden = weakSelf.dataArr.count;
        
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMMsgCell* cell = [YMMsgCell cellDequeueReusableCellWithTableView:tableView];
    cell.model = _dataArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//删除cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YMWeakSelf;
    if (self.tableView.editing == YES) {
        if (![self.selectArr containsObject:_dataArr[indexPath.row]]) {
            [self.selectArr addObject:_dataArr[indexPath.row]];
        }
        DDLog(@"selet == %@",self.selectArr);
    }else{
        YMMsgDetailController* mvc = [[YMMsgDetailController alloc]init];
        mvc.title = @"消息详情";
        mvc.model = _dataArr[indexPath.row];
        // 消息未读
        if (mvc.model.status.integerValue == 1) {
            mvc.refreshBlock = ^(){
                //移除所有的对象
                [weakSelf.dataArr removeAllObjects];
                //刷新获取首页数据
                [weakSelf.tableView.mj_header beginRefreshing];
            };
        }
        [self.navigationController pushViewController:mvc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectArr containsObject:_dataArr[indexPath.row]]) {
        [self.selectArr removeObject:_dataArr[indexPath.row]];
    }
     DDLog(@"selectArr === %@",self.selectArr);
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - UITableViewEdit
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.selectArr containsObject:_dataArr[indexPath.row]]) {
        [self.selectArr addObject:_dataArr[indexPath.row]];
    }
}
#pragma mark - lazy
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
-(NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [[NSMutableArray alloc]init];
    }
    return _selectArr;
}
-(UIView *)placeView{
    if (!_placeView) {
     _placeView = [UIView placeViewWhithFrame:self.tableView.frame placeImgStr:@"iconPlaceholder" placeString:@"您暂时还没有消息！"];
        [self.view addSubview:_placeView];
        _placeView.hidden = YES;
    }
    return _placeView;
}

@end
