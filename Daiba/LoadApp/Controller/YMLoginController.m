//
//  YMLoginController.m
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMLoginController.h"
#import "YMRegistViewController.h"
#import "YMForgetFirstController.h"
#import "HyperlinksButton.h"
#import "UserModel.h"
#import "YMUserManager.h"
#import "RSAEncryptor.h"
#import "YMTabBarController.h"
#import "YMSetLoginPswdController.h"
#import "YMForgetViewController.h"
#import "ExtendButton.h"
#import "WytDeviceFingerPrinting.h"
#import <CoreLocation/CoreLocation.h>
//定位
//#import <JPUSHService.h>
//登陆传递uid 设备别名


@interface YMLoginController ()<UITextFieldDelegate,WytDeviceFingerPrintingDelegate, WytDeviceFingerPrintingContactsDelegate>//CLLocationManagerDelegate

//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFd;
//登陆按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
//账户 手机登陆
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *styleBtnArr;
//显示颜色区分
@property (weak, nonatomic) IBOutlet UILabel *lineView;
//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
//最大长度
@property(nonatomic,assign)NSInteger maxCount;
//标题label
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;

@property(nonatomic,strong)NSTimer* timer;
@property(nonatomic,assign)NSInteger totalTime;
//选择登陆样式
@property(nonatomic,strong)UIButton* selectStyleBtn;

@property (weak, nonatomic) IBOutlet ExtendButton *showSecrectBtn;

//定位
//@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation YMLoginController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    _maxCount = 11; //最多11位
    _totalTime = 60;
    //登陆按钮
    [YMTool viewLayerWithView:_loginBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
    
    if (self.isHiddenBackBtn == NO) {
        //设置返回按钮
        [self setLeftBackButton];
    }
    //开始定位，不断调用其代理方法  ----- 定位改成 设备指纹了
    // [self.locationManager startUpdatingLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//设置返回按钮
-(void)setLeftBackButton{
    UIButton *backButton = [Factory createNavBarButtonWithImageStr:@"back" target:self selector:@selector(back)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.view.backgroundColor = WhiteColor;
}
-(void)back{
    if (self.isToTabBar == YES) {
        //跳转到第一个tabBar
        //修改密码 -- 重新回到主页面
        if (self.tag == 2) {
            //修改密码 -- 重新回到主页面
            YMTabBarController* tab = [[YMTabBarController alloc]init];
            [self presentViewController:tab animated:NO completion:nil];
        }else{
            YMTabBarController* tab = [[YMTabBarController alloc]init];
            [self presentViewController:tab animated:NO completion:nil];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听输入框的 字体 变化
    //canInitBqsSDK方法：用于控制不被频繁初始化。如果设备指纹采集成功了，app不被kill的情况下30分钟内不会重复提交设备信息
    if([[WytDeviceFingerPrinting sharedWytDeviceFingerPrinting] canInitWytSDK]){
        [self initDFSDK];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)initDFSDK {
    //1、添加设备信息采集回调
    [[WytDeviceFingerPrinting sharedWytDeviceFingerPrinting] setWytDeviceFingerPrintingDelegate:self];
    [[WytDeviceFingerPrinting sharedWytDeviceFingerPrinting] setWytDeviceFingerPrintingContactsDelegate:self];
    
    //2、配置初始化参数
    NSDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"daiba" forKey:@"partnerId"];
    [params setValue:@"YES" forKey:@"isGatherContacts"];
    [params setValue:@"YES" forKey:@"isGatherGps"];
    [params setValue:@"YES" forKey:@"isTestingEnv"];
    
    //3、执行初始化
    [[WytDeviceFingerPrinting sharedWytDeviceFingerPrinting] initWytDFSdkWithParams:params];
    
}

#pragma mark - WytDeviceFingerPrintingDelegate
- (void)onWytDFInitSuccess:(NSString *)tokenKey {
    NSLog(@"初始化成功 tokenKey=%@", tokenKey);
    //注意：上传tokenkey时最好再停留几百毫秒的时间（给SDK预留上传设备信息的时间）
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(submitTokenkey) userInfo:nil repeats:NO];
}

- (void)onWytDFInitFailure:(NSString *)resultCode withDesc:(NSString *)resultDesc {
    NSLog(@"SDK初始化失败 resultCode=%@, resultDesc=%@", resultCode, resultDesc);
}

#pragma mark - WytDeviceFingerPrintingContactsDelegate
- (void)onWytDFContactsUploadSuccess:(NSString *)tokenKey {
    NSLog(@"通讯录上传成功 tokenKey=%@", tokenKey);
}

- (void)onWytDFContactsUploadFailure:(NSString *)resultCode withDesc:(NSString *)resultDesc {
    NSLog(@"通讯录上传失败 resultCode=%@, resultDesc=%@", resultCode, resultDesc);
}

#pragma mark - 上传这个tokenkey到贵公司服务器
- (void)submitTokenkey {
    NSString *tokenkey = [[WytDeviceFingerPrinting sharedWytDeviceFingerPrinting] getTokenKey];
    NSLog(@"提交tokenkey:%@", tokenkey);
    
    //发起Http请求
    //....
}

#pragma mark Location and Delegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    if (location) {
        [kUserDefaults setObject:@(coordinate.latitude) forKey:kLatitude];
        [kUserDefaults setObject:@(coordinate.longitude) forKey:kLongitude];
        [kUserDefaults synchronize];
        
        // 2.停止定位
        [manager stopUpdatingLocation];
    }
}
//-(CLLocationManager *)locationManager{
//    if (!_locationManager) {
//        _locationManager = [[CLLocationManager alloc] init];
//        _locationManager.delegate = self;
//        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//            NSLog(@"requestAlwaysAuthorization");
//            [_locationManager requestWhenInUseAuthorization];
//        }
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    }
//    return _locationManager;
//}
//- (void)locationManager:(CLLocationManager *)manager
//       didFailWithError:(NSError *)error
//{
//    // 2.停止定位
//    [manager stopUpdatingLocation];
//    
//    if ([CLLocationManager locationServicesEnabled]  //确定用户的位置服务启用
//        && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
//        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
//    {
//        [YMTool presentAlertViewWithTitle:@"提示" message:@"您的定位服务没有打开，请在设置中开启" cancelTitle:@"取消" cancelHandle:^(UIAlertAction *action) {
//            
//        } sureTitle:@"确定" sureHandle:^(UIAlertAction * _Nullable action) {
//            // 跳转到设置界面
//            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                // url地址可以打开
//                [[UIApplication sharedApplication] openURL:url];
//            }
//        } controller:self];
//    }else{
//        UIAlertView* alerView = [[UIAlertView alloc]initWithTitle:@"定位失败" message:@"网络连接失败，请检查网络！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alerView show];
//    }
//}

#pragma mark - 按钮点击事件
- (IBAction)loginBtnClick:(id)sender {
    
    [self.view endEditing:YES];
    if (_phoneTextFd.text.length == 0) {
        [MBProgressHUD showFail:@"请输入手机号！" view:self.view];
        return;
    }
    
    if (![NSString isMobileNum:_phoneTextFd.text]) {
        [MBProgressHUD showFail:@"手机号码不正确！请重新输入！" view:self.view];
        return;
    }
    
    if (_passwordTextFd.text.length < 6 || _passwordTextFd.text.length > 14) {
        [MBProgressHUD showFail:@"密码格式为6-14位数字或字母，请重新输入！" view:self.view];
        return;
    }
      NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
      NSString* urlStr ;
        urlStr = LoginURL;
        //网络
        if ([YMTool connectedToNetwork]) {
             [param setObject: [YMTool getNetWorkStates] forKey:@"network"];
        }else{
            [param setObject: @"1" forKey:@"network"];
        }
        //手机型号
        if ([YMTool deviceModel]) {
            [param setObject:[YMTool deviceModel] forKey:@"mobile_brand"];
        }else{
            [param setObject:@"iphone" forKey:@"mobile_brand"];
        }
    
        [param setObject:_phoneTextFd.text forKey:@"phone"];
        //加密
        [param setObject:[RSAEncryptor encryptString:_passwordTextFd.text publicKey:kPublicKey]  forKey:@"passwd"];
    //编辑
    [[HttpManger sharedInstance]callHTTPReqAPI:urlStr params:param view:self.view isEdit:YES  loading:YES  tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSNumber* status = responseObject[@"code"];
        NSString* msg    = responseObject[@"msg"];
        //快捷登陆 普通登陆成功
        if (status.longValue == 200) {
            DDLog(@"tag == %ld isBar == %d",(long)self.tag,self.isToTabBar);
            //保存用户信息
            UserModel* usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
            [[YMUserManager shareInstance] saveUserInfoByUsrModel:usrModel];
            //uid
            NSNumber* usrId = responseObject[@"data"][@"uid"];
            DDLog(@"用户的 uid == %@",usrId);
            //调用此 API 来同时设置别名与标签，支持回调函数。
//            [JPUSHService setTags:nil alias:usrId.stringValue fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//                DDLog(@" 上传别名 成功 == %d iTags == %@ ialias == %@",iResCode,iTags,iAlias);
//            }];
           // [JPUSHService setAlias:usrId callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:nil];
            //这个是为了修改密码  返回到首页
            if (self.isToTabBar == YES && self.tag == 2) {
                //可以返回
                //修改密码 -- 重新回到主页面
                YMTabBarController* tab = [[YMTabBarController alloc]init];
                [self presentViewController:tab animated:YES completion:nil];
                return ;
            }
            if (self.tag == 2) {
                //修改密码 -- 重新回到主页面
                YMTabBarController* tab = [[YMTabBarController alloc]init];
                [self presentViewController:tab animated:YES completion:nil];
            }else{
                //回退刷新数据
                [kUserDefaults setBool:YES forKey:kisRefresh];
                [kUserDefaults synchronize];
                //刷新页面
                if (self.refreshWebBlock) {
                    self.refreshWebBlock();
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            //用户信息
            // [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_LoginStatusChanged object:@""];
        }//注册成功
        else if (status.longValue == 2){
            //保存用户信息
            UserModel* usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
            [[YMUserManager shareInstance] saveUserInfoByUsrModel:usrModel];
            //uid
            NSNumber* usrId = responseObject[@"data"][@"uid"];
            DDLog(@"用户的 uid == %@",usrId);
            //调用此 API 来同时设置别名与标签，支持回调函数。
//            [JPUSHService setTags:nil alias:usrId.stringValue fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//                DDLog(@" 上传别名 成功 == %d iTags == %@ ialias == %@",iResCode,iTags,iAlias);
//            }];

            YMSetLoginPswdController* svc = [[YMSetLoginPswdController alloc]init];
            svc.title = @"设置登陆密码";
            [kUserDefaults setBool:YES forKey:kisRefresh];
            [kUserDefaults synchronize];
            svc.loginStatusBlock = ^(){
                _isToTabBar = YES;
            };
            svc.isToTabBar = YES;
            [self.navigationController pushViewController:svc animated:YES];
        }
        else{
            [MBProgressHUD showSuccess:msg view:self.view];
        }
    }];
}
#pragma mark - 极光推送 方法
- (IBAction)forgetBtnClick:(id)sender {
    DDLog(@"忘记密码点击啦");
    
    YMForgetViewController* fvc = [[YMForgetViewController alloc]init];
    fvc.title = @"忘记密码";
    fvc.passwordType = PasswordTypeForget;
    [self.navigationController pushViewController:fvc animated:YES];
}
- (IBAction)registBtnClick:(id)sender {
    DDLog(@"注册按钮点击啦");
    YMRegistViewController* rvc = [[YMRegistViewController alloc]init];
//    rvc.tagBlock = ^(NSInteger tag){
//        DDLog(@"tag == %ld",(long)tag);
//    };
    rvc.tag = 1;
    [self.navigationController pushViewController:rvc animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _phoneTextFd) {
        NSMutableString * mStr = [[NSMutableString alloc] initWithString:textField.text];
        [mStr insertString:string atIndex:range.location];
        return mStr.length <= 11;
    }
    else{
        return YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _passwordTextFd) {
        [self loginBtnClick:_loginBtn];
        return YES;
    }
    return YES;
}

- (IBAction)showSecrectBtnClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _passwordTextFd.secureTextEntry = NO;
    }
    else{
        _passwordTextFd.secureTextEntry = YES;
    }
}

-(void)textDidChangeHandle:(NSNotification* )noti{
    //监听字体处理按钮颜色
    _loginBtn.enabled = [_phoneTextFd.text length] > 0 && [_passwordTextFd.text length] >= 6 ;
    _loginBtn.backgroundColor = _loginBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
    NSString *toBeString = _phoneTextFd.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_phoneTextFd markedTextRange];       //获取高亮部分的range
        //获取高亮部分的从range.start位置开始，向右偏移0所得的字符所在的位置。如果高亮部分不存在，那么就返回nil，反之就不是nil
        UITextPosition *position = [_phoneTextFd positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxCount) {
                _phoneTextFd.text = [toBeString substringToIndex:self.maxCount];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            // _phoneTextFd.text
        }
    }
    // 中文输入法以外的直接对其统计限制即可
    else{
        if (toBeString.length > self.maxCount) {
            _phoneTextFd.text = [toBeString substringToIndex:self.maxCount];
        }
    }
}

@end
