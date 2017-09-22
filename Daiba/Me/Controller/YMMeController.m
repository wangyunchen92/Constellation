//
//  YMMeController.m
//  Daiba
//
//  Created by YouMeng on 2017/7/26.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMeController.h"
#import "YMMeIconCell.h"
#import "YMTitleCell.h"
#import "YMMsgListController.h"
#import "UIImage+Extension.h"
#import "YMForgetViewController.h"
#import "YMSignOutCell.h"
#import "YMSafeSetController.h"
#import "YMHistoryListController.h"

#import "YMProtocalListController.h"
#import "YMHelpBaseController.h"
#import "YMMoreController.h"
#import "YMBankCardListController.h"


@interface YMMeController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
      UIImageView *navBarHairlineImageView;
}
//去掉导航
@property(nonatomic,strong)UIImageView* barImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray* titileArr;
@property(nonatomic,strong)NSArray* iconArr;

//选择图片
@property(nonatomic,strong)UIImagePickerController* imgPickController;

//选择的照片
@property(nonatomic,strong)NSMutableArray* arrSelected;

@property(nonatomic,strong)UserModel* usrModel;

//头部的头像
@property(nonatomic,strong)YMMeIconCell* headIconCell;
//显示框
@property(nonatomic,strong)MBProgressHUD* HUD;


@end

@implementation YMMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self modifyView];
    
    [self requestUserStatusInfoWithIsLoading:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_barImageView ) {
        _barImageView = self.navigationController.navigationBar.subviews.firstObject;
        _barImageView.alpha = 0;
    }
    //再定义一个imageview来等同于这个黑线
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    navBarHairlineImageView.hidden = YES;
    //初始化登陆
    if ([[YMUserManager shareInstance]isValidLogin]) {
        _headIconCell.phoneLabel.text = [kUserDefaults valueForKey:kPhone];
        self.tableView.tableFooterView.hidden = NO;
    }else{
        _headIconCell.phoneLabel.text = @"请登陆";
         self.tableView.tableFooterView.hidden = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
    //恢复之前的导航色
    _barImageView.alpha = 1;
}

//通过一个方法来找到这个黑线(findHairlineImageViewUnder):
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotification_LoginOut object:nil];
}
#pragma mark - modifyView
-(void)modifyView{
    //处理导航 透明问题
    self.tableView.rowHeight = 44;
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = NavBarTintColor;
    
    self.tableView.backgroundColor = BackGroundColor;
    
    //处理导航 透明问题
    _barImageView = self.navigationController.navigationBar.subviews.firstObject;
    _barImageView.alpha = 0;
    
    //设置背景
    UIView* topBgView = [[UIView alloc]init];
    topBgView.backgroundColor = DefaultNavBarColor;
    [self.view insertSubview:topBgView atIndex:1];
    topBgView.sd_layout.topSpaceToView(self.view, - 64).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(self.view.height * 0.5);
    
    //调整tabBar 背景
    self.tableView.sd_layout.bottomSpaceToView(self.view, 49);
    [self.view bringSubviewToFront:self.tableView];
    //    UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    //    UIVisualEffectView *vew = [[UIVisualEffectView alloc]initWithEffect:blur];
    self.tabBarController.tabBar.backgroundColor = WhiteColor;

    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = BackGroundColor;
    YMWeakSelf;
    _headIconCell = [[[NSBundle mainBundle]loadNibNamed:@"YMMeIconCell" owner:nil options:nil] lastObject];
    _headIconCell.changeIconBlock = ^{
        DDLog(@"用户头像点击啦");
        if ([[YMUserManager shareInstance] isValidLogin]) {
           // [weakSelf showActionSheet];
        }else{
            YMLoginController* lvc = [[YMLoginController alloc]init];
            YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
            lvc.hidesBottomBarWhenPushed = YES;
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }
    };
    _headIconCell.usrModel = self.usrModel;
    if ([[YMUserManager shareInstance]isValidLogin]) {
         _headIconCell.phoneLabel.text = [kUserDefaults valueForKey:kPhone];
    }else{
        _headIconCell.phoneLabel.text = @"请登陆";
    }
    self.tableView.tableHeaderView = _headIconCell;
    
    //添加推出按钮
    YMSignOutCell* cell = [YMSignOutCell cellDequeueReusableCellWithTableView:self.tableView];
    cell.signOutBlock = ^(UIButton* signBtn){
        DDLog(@"推出按钮点击啦");
        [kUserDefaults setBool:NO forKey:kisLoginClick];
        [self userLoginOut:nil];
    };
//    cell.y -= 10;
//    cell.height += 10;
    self.tableView.tableFooterView = cell;
 
}
-(void)userLoginOut:(NSNotification* )notification{
    DDLog(@"用户推出登陆");
    _usrModel = nil;
    _headIconCell.usrModel = _usrModel;
    [[YMUserManager shareInstance]removeUserInfo];
    //推出登陆 -- 首页提示登陆
    [kUserDefaults setBool:NO forKey:kisLoginClick];
    
    _headIconCell.phoneLabel.text = @"请登陆";
    self.tableView.tableFooterView.hidden = YES;
    [_tableView reloadData];
}
-(void)requestUserStatusInfoWithIsLoading:(BOOL)isLoading{
    if ([[YMUserManager shareInstance] isValidLogin]) {
        NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
        [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
        [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
        [[HttpManger sharedInstance]callHTTPReqAPI:getUsrStatusURL params:param view:self.view loading:isLoading tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
            self.usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"][@"account"]];
#warning - 测试订单状态
            [self.tableView reloadData];
        }];
    }else{
        [[YMUserManager shareInstance] pushToLoginWithViewController:self];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 2;
    }else{
        return 3;
    }
}

-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMTitleCell* cell = [YMTitleCell cellDequeueReusableCellWithTableView:tableView];
    if (indexPath.section == 0) {
            [cell cellWithTitle:self.titileArr[indexPath.row] icon:self.iconArr[indexPath.row]];
        if (indexPath.row == 1) {
            cell.detaiLabel.text = @"赢免息券";
            [YMTool labelColorWithLabel:cell.detaiLabel font:Font(13) range:NSMakeRange(0,cell.detaiLabel.text.length) color:DefaultBtnColor];
        }
    }
    if (indexPath.section == 1) {
        [cell cellWithTitle:self.titileArr[indexPath.row + 2] icon:self.iconArr[indexPath.row + 2]];

        if (indexPath.row == 1 || indexPath.row == 0 ) {
            cell.detaiLabel.text = @"敬请期待";//[NSString stringWithFormat:@"共%@张免息券可用",@"0"];
        }
    }
     if (indexPath.section == 2) {
          [cell cellWithTitle:self.titileArr[indexPath.row + 4] icon:self.iconArr[indexPath.row + 4]];
         if (indexPath.row == 2) {
             //去掉分割线
             cell.layoutMargins = UIEdgeInsetsZero;
             cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
         }
     }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else{
        return 10;
    }
}
#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDLog(@"点击啦 某一行");
    if ([[YMUserManager shareInstance] isValidLogin]) {
        switch (indexPath.section) {
            case 0:
            {
                //银行卡
                if(indexPath.row == 0){
                    YMBankCardListController* yvc = [[YMBankCardListController alloc]init];
                    yvc.title = @"我的银行卡";
                    yvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:yvc animated:YES];
                }//历史账单
                else if(indexPath.row == 1){
                    YMHistoryListController* yvc = [[YMHistoryListController alloc]init];
                    yvc.title = @"历史账单";
                    yvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:yvc animated:YES];
                }
            }
                break;
            case 1:
            {
                //邀请好友
                if(indexPath.row == 0){
                  

                }//我的免息券
                else if(indexPath.row == 1){
                    self.tabBarController.selectedIndex = 2;
                }
                else if (indexPath.row == 2) {
                  
                }
                break;
            }
                break;
            case 2:
            {
                //帮助中心
                if(indexPath.row == 0){
                    YMHelpBaseController* yvc = [[YMHelpBaseController alloc]init];
                    yvc.title = @"帮助中心";
                    yvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:yvc animated:YES];
                }//安全设置
                else if(indexPath.row == 1){
                    //测试修改密码
                    YMSafeSetController* yvc = [[YMSafeSetController alloc]init];
                    yvc.hidesBottomBarWhenPushed = YES;
                    yvc.title = @"安全设置";
                    [self.navigationController pushViewController:yvc animated:YES];
                }//更多
                else if (indexPath.row == 2) {
                    YMMoreController* mvc = [[YMMoreController alloc]init];
                    mvc.title = @"更多";
                    mvc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:mvc animated:YES];
                }
                break;
            }
                break;
            default:
                break;
        }
        //未登陆跳转到登陆
    }else{
         [[YMUserManager shareInstance]pushToLoginWithViewController:self isShowAlert:NO];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = BackGroundColor;
}

-(void)requestUserDataWithIsPush:(BOOL)isPush{
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"]; //                               //[kUserDefaults valueForKey:kUid]
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];//@"4a70ef79952fbb9cd62eefd0edc139a6"
    [[HttpManger sharedInstance]callHTTPReqAPI:UserPayInfoURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        weakSelf.usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
        //存储用户信息
        [[YMUserManager shareInstance] saveUserInfoByUsrModel:weakSelf.usrModel];
        _headIconCell.usrModel = self.usrModel;
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - 上传头像
-(void)showActionSheet{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择照片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拍照"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!_imgPickController) {
            _imgPickController = [[UIImagePickerController alloc] init];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imgPickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imgPickController.delegate = self;
            //设置导航栏按钮文字的颜色
            [[UINavigationBar appearance]setTintColor:WhiteColor];
            [self presentViewController:_imgPickController animated:YES completion:^{
                //设置导航栏按钮文字的颜色
                // [[UINavigationBar appearance]setTintColor:WhiteColor];
            }];
        }
    }];
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"相册"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (!_imgPickController) {
            _imgPickController = [[UIImagePickerController alloc] init];
        }
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            _imgPickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;;
            _imgPickController.delegate = self;
            //设置导航栏按钮文字的颜色
            [[UINavigationBar appearance]setTintColor:WhiteColor];
            [self presentViewController:_imgPickController animated:YES completion:^{
                //设置导航栏按钮文字的颜色
                //[[UINavigationBar appearance]setTintColor:WhiteColor];
            }];
        }
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:actionCamera];
    [alertController addAction:actionAlbum];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - 拍照获得数据
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *theImage = nil;
    // 判断，图片是否允许修改
    if ([picker allowsEditing]){
        //获取用户编辑之后的图像
        theImage = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        // 照片的元数据参数
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (theImage) {
        //处理图片
        UIImage* newImage = [UIImage compressOriginalImage:theImage toSize:[UIImage comressSizeByImage:theImage]];
        [self updateUserIconWithImage:newImage];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//上传用户icon
-(void)updateUserIconWithImage:(UIImage* )image{
    YMWeakSelf;
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"]; //
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    //加载中
    [self.HUD showAnimated:YES whileExecutingBlock:^{
        [[HttpManger sharedInstance]postFileHTTPReqAPI:uploadUserPicURL params:param imgsArr:@[image] view:self.view loading:NO completionHandler:^(id task, id responseObject, NSError *error) {
            [weakSelf requestUserDataWithIsPush:NO];
        }];
    }];
}
#pragma mark - lazy
-(NSArray *)titileArr{
    if (!_titileArr) {
        _titileArr = @[@"我的银行卡",@"历史账单",@"邀请好友",@"我的免息券",@"帮助中心",@"安全设置",@"更多"];
    }
    return _titileArr;
}
-(NSArray *)iconArr{
    if (!_iconArr) {
        _iconArr = @[@"银行卡",@"账单",@"邀请好友",@"免息券",@"帮助",@"账户安全",@"更多"];
    }
    return _iconArr;
}
- (MBProgressHUD *)HUD{
    if (!_HUD) {
        MBProgressHUD *hud= [[MBProgressHUD alloc] initWithView:KeyWindow];
        [KeyWindow addSubview:hud];
        hud.label.text = @"努力上传中";
        hud.label.font = [UIFont systemFontOfSize:12];
        hud.mode = MBProgressHUDModeIndeterminate;
        //hud.progress = 0;
        _HUD = hud;
    }
    return _HUD;
}

@end
