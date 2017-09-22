//
//  YMRegistViewController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMRegistViewController.h"
#import "YMLoginController.h"
#import "HyperlinksButton.h"
#import "YMTool.h"
#import "YMRegistWebController.h"
#import "YMUserManager.h"
#import "UserModel.h"
//#import "UIView+YSTextInputKeyboard.h"
#import "RSAEncryptor.h"
#import "YMTabBarController.h"
//#import "YMRedBagController.h"
//#import "JPUSHService.h"

@interface YMRegistViewController ()<UIGestureRecognizerDelegate>

//电话号码
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *codeTextFd;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFd;
//邀请码
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTextFd;
//获取验证码
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

//注册诱梦协议
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UILabel *protocalTitleLabel;

//登陆按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//立即注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

//倒计时
@property(nonatomic,assign)NSInteger totalTime;
//timer
@property(nonatomic,strong)NSTimer* timer;
@property(nonatomic,copy)NSString* isAgree;

//最大长度
@property(nonatomic,assign)NSInteger maxCount;
@end

@implementation YMRegistViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新用户注册";
    //初始化view
    [self modifyView];
    
    _maxCount = 11; //最多11位
    //监听字体处理按钮颜色
//    _registBtn.enabled = [_phoneTextFd.text length] > 0 && [_codeTextFd.text length] > 0 && [_passwordTextFd.text length] > 0 ;
//    _registBtn.backgroundColor = _registBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
    _totalTime = 60;
    
    if (self.isPresent == YES) {
        //设置返回按钮
        [self setLeftBackButton];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听输入框的 字体 变化
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textDidChangeHandle:)
//                                                 name:UITextFieldTextDidChangeNotification
//                                              object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UITextFieldTextDidChangeNotification
//                                                  object:nil];
}
-(void)dealloc{
    //取消定时器
    [_timer invalidate];
    _timer = nil;
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
//返回
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UI
-(void)modifyView{
    //设置layer
    //设置圆角
    self.view.backgroundColor = WhiteColor;
    
    _getCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [YMTool viewLayerWithView:_getCodeBtn cornerRadius:4 boredColor:BackGroundColor borderWidth:1];
    [YMTool viewLayerWithView:_registBtn cornerRadius:4 boredColor:nil borderWidth:1];
    //注册协议
    //[YMTool labelColorWithLabel:_protocolLabel font:Font(12) range:NSMakeRange(_protocolLabel.text.length - 6, 6) color:RedColor];
    //登陆按钮
//    [self.loginBtn setColor:NavBarTintColor];
    //添加协议
     _protocolLabel.userInteractionEnabled = YES;
    [YMTool addTapGestureOnView:_protocolLabel target:self selector:@selector(protocolLabelClick:) viewController:self];
    _protocalTitleLabel.userInteractionEnabled = YES;
    [YMTool addTapGestureOnView:_protocalTitleLabel target:self selector:@selector(protocolLabelClick:) viewController:self];
}
#pragma mark - 按钮响应方法
- (IBAction)showSecrectBtnClick:(UIButton* )sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _passwordTextFd.secureTextEntry = NO;
    }
    else{
        _passwordTextFd.secureTextEntry = YES;
    }

}
//获取验证码
- (IBAction)getCodeBtnClick:(id)sender {
    if (_phoneTextFd.text.length == 0) {
        [MBProgressHUD showFail:@"请输入手机号码！" view:self.view];
        return;
    }
    if (![NSString isMobileNum:_phoneTextFd.text]) {
        [MBProgressHUD showFail:@"手机号码有误，请重新输入！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:_phoneTextFd.text forKey:@"phone"];
//    [param setObject:@"register" forKey:@"method"];
    [param setObject:@"ios" forKey:@"source"];
    [param setObject:@"38" forKey:@"tpl_id"];
 
    [[HttpManger sharedInstance]callHTTPReqAPI:SendMsgCodeURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSString* msg    = responseObject[@"msg"];
        //显示提示信息
        [MBProgressHUD showFail:msg view:self.view];
        NSNumber* status = responseObject[@"code"];
        //成功才会倒计时
        if (status.integerValue == 200) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCodeMessage) userInfo:nil repeats:YES];
        }
    }];
}
-(void)getCodeMessage{
  //  DDLog(@"获取验证码 倒计时");
    _totalTime --;
    if (_totalTime != 0 ) {
        _getCodeBtn.userInteractionEnabled = NO;
        [_getCodeBtn setBackgroundColor:LightGrayColor];
        [_getCodeBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.text = [NSString stringWithFormat:@"   已发送%lds",(long)_totalTime];
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
- (IBAction)loginBtnClick:(id)sender {
    DDLog(@"点击啦登陆按钮");
    if (self.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        YMLoginController* lvc = [[YMLoginController alloc]init];
        [self.navigationController pushViewController:lvc animated:YES];
    }
}
//注册用户
- (IBAction)regestBtnClick:(id)sender {
    DDLog(@"注册用户");
     [self.view endEditing:YES];
    if (![NSString isMobileNum:_phoneTextFd.text]) {
        [MBProgressHUD showFail:@"手机号码不正确！请重新输入！" view:self.view];
        return;
    }
    if (_passwordTextFd.text.length < 6 || _passwordTextFd.text.length > 14) {
        [MBProgressHUD showFail:@"密码格式为6-14位数字或字母，请重新输入！" view:self.view];
        return;
    }
    if (self.codeTextFd.text.length < 6 ) {
        [MBProgressHUD showFail:@"验证码格式不正确，请重新输入！" view:self.view];
        return;
    }

    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:_phoneTextFd.text forKey:@"phone"];
    [param setObject:_codeTextFd.text forKey:@"captcha"];
    //网络
    [param setObject: [YMTool getNetWorkStates] forKey:@"network"];
    //手机型号
    if ([YMTool deviceModel]) {
        [param setObject:[YMTool deviceModel] forKey:@"mobile_brand"];
    }else{
       [param setObject:@"iphone" forKey:@"mobile_brand"];
    }
    
    
    [param setObject:[RSAEncryptor encryptString:_passwordTextFd.text publicKey:kPublicKey] forKey:@"passwd"];//_passwordTextFd.text
   // [param setObject:@"1" forKey:@"isAgreement"];
    if (_inviteCodeTextFd.text) {
         [param setObject:_inviteCodeTextFd.text forKey:@"sharecode"];
    }
    [[HttpManger sharedInstance]callHTTPReqAPI:RegisterURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
            //保存数据
            UserModel* usrModel = [UserModel mj_objectWithKeyValues:responseObject[@"data"]];
            [[YMUserManager shareInstance] saveUserInfoByUsrModel:usrModel];
        
           //uid
           // NSNumber* usrId = responseObject[@"data"][@"uid"];
           // DDLog(@"用户的 uid == %@",usrId);
            //注册成功后跳转到主页
            YMTabBarController* tab = [[YMTabBarController alloc]init];
            [self presentViewController:tab animated:YES completion:nil];
        
               //调用此 API 来同时设置别名与标签，支持回调函数。
//               [JPUSHService setTags:nil alias:usrId.stringValue fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//                   DDLog(@" 上传别名 成功 == %d iTags == %@ ialias == %@",iResCode,iTags,iAlias);
//               }];


//               YMRedBagController* rvc = [[YMRedBagController alloc]init];
//               rvc.title = @"我的红包";
//               rvc.isToTabBar = YES;
//               [kUserDefaults setBool:YES forKey:kisRefresh];
//               [kUserDefaults synchronize];
//               rvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",RedPaperListURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
//               [self.navigationController pushViewController:rvc animated:YES];
//               
//           }else{
//               [MBProgressHUD showFail:msg view:self.view];
//           }
    }];
}
//注册协议
-(void)protocolLabelClick:(UITapGestureRecognizer* )tap{
    DDLog(@"点击啦协议");
    YMRegistWebController* wvc = [[YMRegistWebController alloc]init];
    wvc.title   =  @"贷吧注册协议";
    wvc.urlStr  =  RegistProtocalURL;
    [self.navigationController pushViewController:wvc animated:YES];
}
#pragma mark - UITextFieldDelegate
-(void)textDidChangeHandle:(NSNotification* )notification{
    //监听字体处理按钮颜色
    _registBtn.enabled = [_phoneTextFd.text length] > 0 && [_codeTextFd.text length] > 0 && [_passwordTextFd.text length] > 0 ;
    _registBtn.backgroundColor = _registBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
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

#pragma mark - 键盘处理
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
