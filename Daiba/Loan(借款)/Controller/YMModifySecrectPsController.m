//
//  YMModifySecrectPsController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/5.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMModifySecrectPsController.h"
#import "RSAEncryptor.h"


@interface YMModifySecrectPsController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFd;
@property (weak, nonatomic) IBOutlet UITextField *idTextFd;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextFd;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

//提交按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

//倒计时
@property(nonatomic,assign)NSInteger totalTime;
//timer
@property(nonatomic,strong)NSTimer* timer;

@end

@implementation YMModifySecrectPsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _totalTime = 60;
    [YMTool viewLayerWithView:_codeBtn cornerRadius:5 boredColor:DefaultNavBarColor borderWidth:1];
    [YMTool viewLayerWithView:_sureBtn cornerRadius:5 boredColor:ClearColor borderWidth:1];
    
    //不可修改
    _phoneTextFd.text = [kUserDefaults valueForKey:kPhone];
    _phoneTextFd.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    //取消定时器
    [_timer invalidate];
    _timer = nil;
}
- (IBAction)codeBtnClick:(id)sender {
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

    [param setObject:@"40" forKey:@"tpl_id"];
    
    [[HttpManger sharedInstance]callHTTPReqAPI:SendMsgCodeURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSString* msg  = responseObject[@"msg"];
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
    _totalTime --;
    if (_totalTime != 0 ) {
        _codeBtn.userInteractionEnabled = NO;
        [_codeBtn setBackgroundColor:LightGrayColor];
         [YMTool viewLayerWithView:_codeBtn cornerRadius:5 boredColor:ClearColor borderWidth:1];
        [_codeBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        _codeBtn.titleLabel.text = [NSString stringWithFormat:@"  已发送%lds",(long)_totalTime];
    }
    else{
         [YMTool viewLayerWithView:_codeBtn cornerRadius:5 boredColor:DefaultNavBarColor borderWidth:1];
        _codeBtn.userInteractionEnabled = YES;
        _codeBtn.titleLabel.text = @"  获取验证码";
        _codeBtn.backgroundColor  = WhiteColor;
        [_codeBtn setTitleColor:BlackColor forState:UIControlStateNormal];
        _totalTime = 60;
        //先停止，然后再某种情况下再次开启运行timer
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
    }

}
- (IBAction)uploadBtnClick:(id)sender {
    DDLog(@"提交修改密码");
    if (_passwdTextFd.text.length < 6 || _passwdTextFd.text.length > 14 ) {
        [MBProgressHUD showFail:@"密码格式为6-14位数字或字母，请重新输入！" view:self.view];
        return;
    }
    if (_idTextFd.text.length != 6) {
        [MBProgressHUD showFail:@"身份证后六位输入格式不正确，请重新输入！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[RSAEncryptor encryptString:_passwdTextFd.text publicKey:kPublicKey] forKey:@"borrow_passwd"];
    [param setObject:_codeTextFd.text forKey:@"captcha"];
    [param setObject:_phoneTextFd.text forKey:@"phone"];
    [param setObject:_idTextFd.text forKey:@"card_number_6"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    
    [[HttpManger sharedInstance]callHTTPReqAPI:updateBorrowPswdURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
//        if (self.refreshStateBlock) {
//            self.refreshStateBlock(YES);
//        }
        [self.navigationController popViewControllerAnimated:YES];
    }];

}
- (IBAction)showSecrectBtnClick:(UIButton *)sender {
     sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _passwdTextFd.secureTextEntry = NO;
    }
    else{
        _passwdTextFd.secureTextEntry = YES;
    }
}


@end
