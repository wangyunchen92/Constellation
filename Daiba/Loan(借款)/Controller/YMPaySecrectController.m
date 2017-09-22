//
//  YMPaySecrectController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/5.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMPaySecrectController.h"
#import "RSAEncryptor.h"

@interface YMPaySecrectController ()<UITextFieldDelegate>
//密码
@property (weak, nonatomic) IBOutlet UITextField *firstPsTextFd;
@property (weak, nonatomic) IBOutlet UITextField *secondPsTextFd;
@property (weak, nonatomic) IBOutlet UITextField *loginTextFd;
@property (weak, nonatomic) IBOutlet UITextField *idTextFd;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation YMPaySecrectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //修改界面
    [self modifyView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)modifyView{
    [YMTool viewLayerWithView:_sureBtn cornerRadius:5 boredColor:ClearColor borderWidth:1];
}

- (IBAction)sureBtnClick:(id)sender {
    DDLog(@"点击啦提交按钮");
    
    if (_firstPsTextFd.text.length < 6 ||_firstPsTextFd.text.length > 14 ||  _secondPsTextFd.text.length < 6 || _secondPsTextFd.text.length > 14 || _loginTextFd.text.length < 6 || _loginTextFd.text.length > 14) {
        [MBProgressHUD showFail:@"密码格式为6-14位数字或字母，请重新输入！" view:self.view];
        return;
    }
    if (![_firstPsTextFd.text isEqualToString:_secondPsTextFd.text]) {
        [MBProgressHUD showFail:@"两次输入的密码不一致，请重新输入！" view:self.view];
        return;
    }
    if (_idTextFd.text.length != 6) {
        [MBProgressHUD showFail:@"身份证后六位输入格式不正确，请重新输入！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[RSAEncryptor encryptString:_firstPsTextFd.text publicKey:kPublicKey] forKey:@"borrow_passwd"];
    [param setObject:[RSAEncryptor encryptString:_secondPsTextFd.text publicKey:kPublicKey] forKey:@"borrow_repasswd"];
    [param setObject:[RSAEncryptor encryptString:_loginTextFd.text publicKey:kPublicKey] forKey:@"login_passwd"];
    [param setObject:_idTextFd.text forKey:@"card_number_6"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    
    [[HttpManger sharedInstance]callHTTPReqAPI:setBorrowPswdURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        if (self.refreshStateBlock) {
            self.refreshStateBlock(YES,_firstPsTextFd.text);
            [kUserDefaults setBool:YES forKey:kIsSetPaySecrect];
            [kUserDefaults synchronize];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}

@end
