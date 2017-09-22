//
//  YMForgetFirstController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/8.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMForgetFirstController.h"
#import "YMForgetViewController.h"
#import "PooCodeView.h"

@interface YMForgetFirstController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;
@property (weak, nonatomic) IBOutlet UITextField *imgCodeTextFd;
//图形验证码
@property (weak, nonatomic) IBOutlet UIImageView *codeImgView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

//存储cookie
@property(nonatomic,strong)NSHTTPCookie *cookie;
//验证码view
@property (weak, nonatomic) IBOutlet PooCodeView *codeView;
//cookie字符串
@property(nonatomic,strong)NSString* cookiesStr;
@end

@implementation YMForgetFirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    // _phoneTextFd.text = @"15376335161";
    //加载验证图片
    //[self getNewCodeImgClick:nil];
    //添加图片
    //_codeImgView.userInteractionEnabled = YES;
    //[YMTool addTapGestureOnView:_codeImgView target:self selector:@selector(getNewCodeImgClick:) viewController:self];
    [_codeView changeCode];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_codeView addGestureRecognizer:tap];
    
    //监听字体处理按钮颜色
    _nextBtn.enabled = [_phoneTextFd.text length] > 0 && [_imgCodeTextFd.text length] > 0  ;
    _nextBtn.backgroundColor = _nextBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    //设置layer
    [YMTool viewLayerWithView:_nextBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    _nextBtn.enabled = [_phoneTextFd.text length] > 0 && [_imgCodeTextFd.text length] > 0  ;
    _nextBtn.backgroundColor = _nextBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    
}
-(void)tapClick:(UITapGestureRecognizer* )tap{
    DDLog(@"点击啦验证");
     [_codeView changeCode];
    
    DDLog(@"changeStr == %@",_codeView.changeString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)nextBtnClick:(id)sender {
    DDLog(@"点击啦下一步");
    if (_phoneTextFd.text == nil) {
        [MBProgressHUD showFail:@"请输入手机号码！" view:self.view];
        return;
    }
    if (![NSString isMobileNum:_phoneTextFd.text]) {
        [MBProgressHUD showFail:@"您的手机号码不正确，请重新输入！" view:self.view];
        return;
    }
    if (_imgCodeTextFd.text.length != 4) {
        [MBProgressHUD showFail:@"您的验证码格式不正确！" view:self.view];
        return;
    }
    //模糊比较字符串
    BOOL result = [_codeView.changeString compare:_imgCodeTextFd.text
                                          options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame;
    DDLog(@"result == %d",result);
    if (result == NO) {
        //验证不匹配，验证码和输入框晃动
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        anim.repeatCount = 1;
        anim.values = @[@-20, @20, @-20];
        [_codeView.layer addAnimation:anim forKey:nil];
        [_imgCodeTextFd.layer addAnimation:anim forKey:nil];
        // [MBProgressHUD showFail:@"您输入的验证码不正确！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:_imgCodeTextFd.text forKey:@"FindCaptcha"];
    [param setObject:_phoneTextFd.text forKey:@"username"];
    AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
    httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    //保存 cookie
    // NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    // [cookieStorage setCookie:self.cookie];
    
    //[cookieStorage setCookies:self.cookie forURL:url mainDocumentURL:nil];
    
   // [httpMgr.requestSerializer setValue:self.cookiesStr forHTTPHeaderField:@"Cookie"];
    //设置cookie

    [httpMgr POST:ForgetImgCodeCheckURL parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         DDLog(@"res == %@",resObj);
        NSNumber* status = resObj[@"status"];
        NSString* msg    = resObj[@"msg"];
        if (status.longValue == 1) {
            [kUserDefaults setObject:resObj[@"data"][@"token"] forKey:kToken];
            [kUserDefaults synchronize];
            YMForgetViewController* fvc = [[YMForgetViewController alloc]init];
            fvc.title = @"忘记密码-安全验证";
            fvc.passwordType = PasswordTypeForget;
            fvc.phoneStr     = _phoneTextFd.text;
            [self.navigationController pushViewController:fvc animated:YES];
        }else{
            [MBProgressHUD showFail:msg view:self.view];
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD showFail:@"网络连接失败，请稍后重试！" view:self.view];
    }];
}
#pragma mark - cookie

//-(void)getNewCodeImgClick:(NSNotification* )notifi{
//        AFHTTPSessionManager *httpMgr = [AFHTTPSessionManager manager];
//        httpMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [httpMgr GET:@"http://passport.youmeng.com/captcha/regcaptcha" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        id resObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        DDLog(@" resObj == %@  task == %@",resObj,task);
//        //清除缓存
//        [[SDImageCache sharedImageCache] clearMemory];
//        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
//        [_codeImgView sd_setImageWithURL:[NSURL URLWithString:@"http://passport.youmeng.com/captcha/regcaptcha"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
//
//        [self setCookies];
//        //保存cookie
//        //[self saveCookies];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
//}

//-(void)setCookies{
//    NSString *cookie_value;
//    NSString *cookie_domain;
//    NSString *cookie_name;
//    NSString *cookie_path;
//    NSInteger cookie_version = 0;
//
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString: @"http://passport.youmeng.com/captcha/regcaptcha"]];
//    DDLog(@"cookies == %@",cookies);
//   // self.cookiesStr = cookies[0];
//
//    NSEnumerator *enumerat = [cookies objectEnumerator];
//    NSHTTPCookie *cookie;
//    while (cookie = [enumerat nextObject]) {
//        if ([cookie.name isEqualToString:@"PHPSESSID"]) {
//            cookie_name = [cookie name];
//             cookie_value = [cookie value];
//            cookie_domain = [cookie domain];
//            cookie_version = [cookie version];
//            cookie_path = [cookie path];
//        }
//        DDLog(@" name = %@ \n value = %@ \n domain = %@ \n version = %ld \n  path = %@\n",cookie_name,cookie_value,cookie_domain,(long)cookie_version,cookie_path);
//    }
//    NSLog(@"%@",cookie_value);
//    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//    [cookieProperties setObject:cookie_name forKey:NSHTTPCookieName];
//    [cookieProperties setObject:cookie_value forKey:NSHTTPCookieValue];
//    [cookieProperties setObject:cookie_domain forKey:NSHTTPCookieDomain];
//    [cookieProperties setObject:cookie_domain forKey:NSHTTPCookieOriginURL];
//    [cookieProperties setObject:cookie_path forKey:NSHTTPCookiePath];
//    [cookieProperties setObject:@(cookie_version).stringValue forKey:NSHTTPCookieVersion];
//   //  [cookieProperties setObject:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];//设置失效时间
//   //  [cookieProperties setObject:@"1" forKey:NSHTTPCookieDiscard]; //设置sessionOnly
//    NSHTTPCookie *cookieNew = [NSHTTPCookie cookieWithProperties:cookieProperties];
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieNew];
//    self.cookie = cookieNew;
//}
//加载cookie
//- (void)loadCookies{
//
//    NSArray *loadcookiesarray = [NSKeyedUnarchiver unarchiveObjectWithData: [kUserDefaults objectForKey:kSessionCookie]];
//    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//
//    for (NSHTTPCookie *cookies in loadcookiesarray){
//        [cookieStorage setCookie: cookies];
//    }
//
//    //删除cookie
//    //NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
////    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
////    for (id obj in _tmpArray) {
////        [cookieJar deleteCookie:obj];
////    }
//}
//保存cookie
//- (void)saveCookies{
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://passport.youmeng.com/captcha/regcaptcha"]];
//
//    NSData *savecookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
//    DDLog(@"cookies == %@ cookie == %@",cookies,[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
//    [kUserDefaults setObject: savecookiesData forKey:kSessionCookie];
//    [kUserDefaults synchronize];
//
//}

@end
