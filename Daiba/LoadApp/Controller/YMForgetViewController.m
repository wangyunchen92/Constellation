//
//  YMForgetViewController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMForgetViewController.h"
#import "YMResetPasswordController.h" //忘记重置密码
#import "YMModifyPasswdController.h"  //修改密码
#import "RSAEncryptor.h"

@interface YMForgetViewController ()<UITextFieldDelegate>

//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFd;

//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

//登陆密码 ／ 确认登陆密码
@property (weak, nonatomic) IBOutlet UITextField *firstTextFd;
//@property (weak, nonatomic) IBOutlet UITextField *secondTextFd;


//倒计时
@property(nonatomic,assign)NSInteger totalTime;
//timer
@property(nonatomic,strong)NSTimer* timer;

@end

@implementation YMForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _totalTime = 60;
    
//    //监听字体处理按钮颜色
//    _nextBtn.enabled = [_phoneTextFd.text length] > 0 && [_passwordTextFd.text length] >= 6 && _firstTextFd.text.length >= 6 && _secondTextFd.text.length >= 6 ;
//    _nextBtn.backgroundColor = _nextBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
    //设置layer
    [YMTool viewLayerWithView:_getCodeBtn cornerRadius:4 boredColor:BackGroundColor borderWidth:1];
    [YMTool viewLayerWithView:_nextBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
    
    //修改密码
    if (self.passwordType == PasswordTypeModify) {
        if ([kUserDefaults valueForKey:kPhone]) {
            _phoneTextFd.text = [kUserDefaults valueForKey:kPhone];
            _phoneTextFd.userInteractionEnabled = NO;
        }
    }
    //忘记密码
    if (self.passwordType == PasswordTypeForget) {
        _phoneTextFd.text = _phoneStr;
//      _phoneTextFd.userInteractionEnabled = NO;
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听输入框的 字体 变化
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textDidChangeHandle:)
//                                                 name:UITextFieldTextDidChangeNotification
//                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UITextFieldTextDidChangeNotification
//                                                object:nil];
    
}
-(void)dealloc{
    //取消定时器
    [_timer invalidate];
    _timer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)textDidChangeHandle:(NSNotification* )noti{
    //监听字体处理按钮颜色
    _nextBtn.enabled = [_phoneTextFd.text length] > 0 && [_passwordTextFd.text length] >= 6 && _firstTextFd.text.length >= 6  ;
    _nextBtn.backgroundColor = _nextBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
}
// 获取验证码
- (IBAction)getCodeBtnClick:(id)sender {
    if (_phoneTextFd.text.length == 0) {
        [MBProgressHUD showFail:@"请输入手机号码！" view:self.view];
        return;
    }
    if (![NSString isMobileNum:_phoneTextFd.text]) {
        [MBProgressHUD showFail:@"手机号码有误，请重新输入！" view:self.view];
        return;
    }
    NSString* urlStr ;
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    //修改密码
    if (self.passwordType == PasswordTypeModify) {
        [param setObject:_phoneTextFd.text forKey:@"phone"];
        [param setObject:@"ios" forKey:@"source"];
        [param setObject:@"39" forKey:@"tpl_id"];

        urlStr = SendMsgCodeURL;
    }else{
        //忘记密码
        [param setObject:_phoneTextFd.text forKey:@"phone"];
        [param setObject:@"ios" forKey:@"source"];
        [param setObject:@"41" forKey:@"tpl_id"];
        urlStr = SendMsgCodeURL;
    }
    
    [[HttpManger sharedInstance]callHTTPReqAPI:urlStr params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
//        NSNumber* status = responseObject[@"code"];
        NSString* msg    = responseObject[@"msg"];
         [_passwordTextFd becomeFirstResponder];
        //显示提示信息
        [MBProgressHUD showFail:msg view:self.view];
       // if (status.integerValue == 200) {
            _timer   = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCodeMessage) userInfo:nil repeats:YES];
      //  }
    }];
}
-(void)getCodeMessage{
   // DDLog(@"获取验证码 倒计时");
    _totalTime --;
    if (_totalTime != 0 ) {
        _getCodeBtn.userInteractionEnabled = NO;
        [_getCodeBtn setBackgroundColor:LightGrayColor];
        [_getCodeBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.text = [NSString stringWithFormat:@"  已发送%lds",(long)_totalTime];
    }
    else{
        _getCodeBtn.userInteractionEnabled = YES;
        _getCodeBtn.titleLabel.text = @"  获取验证码";
        _getCodeBtn.backgroundColor  = WhiteColor;
        [_getCodeBtn setTitleColor:BlackColor forState:UIControlStateNormal];
        _totalTime = 60;
        //先停止，然后再某种情况下再次开启运行timer
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
    }
}
#pragma mark - 按钮点击事情

- (IBAction)nextBtnClick:(id)sender{
    DDLog(@"点击啦密码下一步");
    if (_phoneTextFd.text.length == 0) {
        [MBProgressHUD showFail:@"请输入手机号码！" view:self.view];
        return;
    }
    if (![NSString isMobileNum:_phoneTextFd.text]) {
        [MBProgressHUD showFail:@"手机号码有误，请重新输入！" view:self.view];
        return;
    }
    if (_passwordTextFd.text.length < 6) {
        [MBProgressHUD showFail:@"验证码格式不正确，请重新输入！" view:self.view];
        return;
    }
//    //判断密码
    if (_firstTextFd.text.length < 6 || _firstTextFd.text.length > 14 ) {
        [MBProgressHUD showFail:@"密码为6-14位的字母或数字，请重新输入！" view:self.view];
        return;
    }
    //    if (_secondTextFd.text.length < 6 || _secondTextFd.text.length > 14) {
    //        [MBProgressHUD showFail:@"密码为6-14位的字母或数字，请重新输入！" view:self.view];
    //        return;
    //    }

//    if (![_firstTextFd.text isEqualToString:_secondTextFd.text]) {
//        [MBProgressHUD showFail:@"两次输入的密码不一致，请重新输入！" view:self.view];
//        return;
//    }

     NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
     NSString* urlStr ;
    //修改密码
    if (self.passwordType == PasswordTypeModify) {
        [param setObject:_phoneTextFd.text forKey:@"phone"];
        [param setObject:@"ios" forKey:@"source"];
         [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
        
        [param setObject:_passwordTextFd.text forKey:@"captcha"];
        [param setObject:[RSAEncryptor encryptString:_firstTextFd.text publicKey:kPublicKey] forKey:@"passwd"];
         [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
        urlStr =  updatePasswordURL;
    }else{
        //忘记密码
        urlStr = ForgetSetPasswdURL;
        [param setObject:@"ios" forKey:@"source"];
        [param setObject:_phoneTextFd.text forKey:@"phone"];
        [param setObject:_passwordTextFd.text forKey:@"captcha"];
        [param setObject:[RSAEncryptor encryptString:_firstTextFd.text publicKey:kPublicKey] forKey:@"passwd"];
    }
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:urlStr params:param view:self.view isEdit:YES loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {

        NSNumber* status = responseObject[@"code"];
        NSString* msg    = responseObject[@"msg"];
        if (status.integerValue == 200) {
            YMLoginController* lvc = [[YMLoginController alloc]init];
            lvc.tag = 2;
            lvc.isToTabBar = YES;
            //忘记 ／ 修改密码
            [[YMUserManager shareInstance] removeUserInfo];
            YMNavigationController* nav = [[YMNavigationController alloc]initWithRootViewController:lvc];
            [self presentViewController:nav animated:YES completion:nil];

//            YMResetPasswordController* rvc = [[YMResetPasswordController alloc]init];
//            rvc.passwordType = self.passwordType;
//            if (self.passwordType == PasswordTypeModify) {
//                rvc.title = @"修改密码";
//            }else{
//                [kUserDefaults setObject:responseObject[@"data"][@"token"] forKey:kToken];
//                [kUserDefaults synchronize];
//                rvc.title = @"找回密码-重置密码";
//            }
//            [weakSelf.navigationController pushViewController:rvc animated:YES];
        }else{
            //显示提示信息
            [MBProgressHUD showFail:msg view:weakSelf.view];
        }
    }];
}
- (IBAction)showSecrectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _firstTextFd.secureTextEntry = NO;
    }
    else{
        _firstTextFd.secureTextEntry = YES;
    }
}

//推出键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
