//
//  YMSetLoginPswdController.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/11.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMSetLoginPswdController.h"
#import "RSAEncryptor.h"
//#import "YMRedBagController.h"
#import "YMTabBarController.h"

@interface YMSetLoginPswdController ()

//第一次密码
@property (weak, nonatomic) IBOutlet UITextField *firstPasswordTextFd;
//确认密码
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTextFd;
//确认按钮
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;


@end

@implementation YMSetLoginPswdController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置返回按钮
    [self setLeftBackButton];
    //修改设置圆角
    [self subViewLayerModified];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听输入框的 字体 变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChangeHandle:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
}
-(void)textDidChangeHandle:(NSNotification* )noti{
    //监听字体处理按钮颜色
    _doneBtn.enabled = [_firstPasswordTextFd.text length] > 0 && [_secondPasswordTextFd.text length] > 0  ;
    _doneBtn.backgroundColor = _doneBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - UI
-(void)subViewLayerModified{
    //监听字体处理按钮颜色
    _doneBtn.enabled = [_firstPasswordTextFd.text length] > 0 && [_secondPasswordTextFd.text length] > 0  ;
    _doneBtn.backgroundColor = _doneBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    //设置颜色
    [YMTool viewLayerWithView:_doneBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
}
//设置返回按钮
-(void)setLeftBackButton{
    UIButton *backButton = [Factory createNavBarButtonWithImageStr:@"back" target:self selector:@selector(back)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.view.backgroundColor = BackGroundColor;
}
-(void)back{

    if (self.isToTabBar == YES) {
        //设置密码返回跳转 到主页面
        YMTabBarController* tab = [[YMTabBarController alloc]init];
        [self presentViewController:tab animated:YES completion:nil];
    }
}
- (IBAction)sureBtnClick:(id)sender {
    DDLog(@"完成按钮点击啦");
    if (_firstPasswordTextFd.text.length < 6 || _firstPasswordTextFd.text.length > 14) {
        [MBProgressHUD showFail:@"密码为6-14位的字母或数字，请重新输入！" view:self.view];
        return;
    }
    if (_secondPasswordTextFd.text.length < 6 || _secondPasswordTextFd.text.length > 14 ) {
        [MBProgressHUD showFail:@"密码为6-14位的字母或数字，请重新输入！" view:self.view];
        return;
    }
    if (![_firstPasswordTextFd.text isEqualToString:_secondPasswordTextFd.text]) {
        [MBProgressHUD showFail:@"两次输入的密码不一致，请重新输入！" view:self.view];
        return;
    }
    YMWeakSelf;
    NSString* urlStr;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    urlStr = updatePasswordURL;//修改密码
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];//[kUserDefaults valueForKey:kUid]
    [param setObject:[RSAEncryptor encryptString:_firstPasswordTextFd.text publicKey:kPublicKey] forKey:@"passwd"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    [param setObject:@"quickLogin" forKey:@"type"];
    
    [[HttpManger sharedInstance]callHTTPReqAPI:urlStr params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSNumber* status = responseObject[@"status"];
        NSString* msg    = responseObject[@"msg"];
        if (status.integerValue == 1) {
//            YMRedBagController* rvc = [[YMRedBagController alloc]init];
//            rvc.title = @"我的红包";
//            rvc.isToTabBar = YES;
//            [kUserDefaults setBool:YES forKey:kisRefresh];
//            [kUserDefaults synchronize];
//            rvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&ssotoken=%@",RedPaperListURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
//            [self.navigationController pushViewController:rvc animated:YES];
        }else{
            //显示提示信息
            [MBProgressHUD showFail:msg view:weakSelf.view];
        }
    }];
}

@end
