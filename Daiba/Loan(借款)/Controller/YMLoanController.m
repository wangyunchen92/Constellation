//
//  YMLoanController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/4.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMLoanController.h"
#import "LoanUseModel.h"
#import "SelectPickerView.h"
#import "BankModel.h"
#import "YMDataManager.h"
#import "YMPaySecrectController.h"
#import "YMModifySecrectPsController.h"
#import "ExtendButton.h"
#import "RSAEncryptor.h"
#import "YMWebViewController.h"
#import "YMBankCardListController.h"

#import "UILabel+YBAttributeTextTapAction.h"


@interface YMLoanController ()<SelectPickerDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *loanMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *useTextFd;
@property (weak, nonatomic) IBOutlet UITextField *passwdFd;
//设置支付密码 btn
@property (weak, nonatomic) IBOutlet UIButton *setPayScrectBtn;


@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UITextField *codeTextFd;

//银行卡
@property (weak, nonatomic) IBOutlet UIImageView *cardImgView;

//
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;

//立即借款按钮
@property (weak, nonatomic) IBOutlet UIButton *loanBtn;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
//协议

@property (weak, nonatomic) IBOutlet UILabel *protocalLabel;
@property (weak, nonatomic) IBOutlet UITextView *protocalTextView;

@property (weak, nonatomic) IBOutlet ExtendButton *protocalBtn;

//借款用途数据数组
@property(nonatomic,strong)NSMutableArray* loanUseArr;
@property(nonatomic,strong)BankModel* bankModel;

//倒计时
@property(nonatomic,assign)NSInteger totalTime;
//timer
@property(nonatomic,strong)NSTimer* timer;

//黑线
@property(nonatomic,strong)UIImageView* navBarHairlineImageView;
//去掉导航
@property(nonatomic,strong)UIImageView* barImageView;

@property(nonatomic,strong)NSNumber* isSetPayPassword;
//平台服务费率
@property(nonatomic,copy)NSString* platform_rate;
@end

@implementation YMLoanController

- (void)viewDidLoad {
    [super viewDidLoad];
    _totalTime = 60;
    //请求借款用途
    [self requestLoanUseData];
    //修改界面
    [self modifyView];
}
-(void)dealloc{
    //取消定时器
    [_timer invalidate];
    _timer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //再定义一个imageview来等同于这个黑线
    _navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    _navBarHairlineImageView.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _navBarHairlineImageView.hidden = NO;
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


#pragma mark - UI
-(void)modifyView{
    _passwdFd.delegate = self;
    
    self.topView.backgroundColor = DefaultNavBarColor;
    _loanMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",self.loanMoney];
    [YMTool viewLayerWithView:_codeBtn cornerRadius:5 boredColor:DefaultNavBarColor borderWidth:1];
    [YMTool viewLayerWithView:_loanBtn cornerRadius:5 boredColor:DefaultNavBarColor borderWidth:1];
    //设置协议 事件
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:@"本人已阅读并同意签署《个人信用贷款合同》、《贷吧标准化服务协议》、《人行征信授权协议》"];
     [attrStr addAttribute:NSForegroundColorAttributeName value:BlueBtnColor range:NSMakeRange(10, 10)];
     [attrStr addAttribute:NSForegroundColorAttributeName value:BlueBtnColor range:NSMakeRange(21, 11)];
     [attrStr addAttribute:NSForegroundColorAttributeName value:BlueBtnColor range:NSMakeRange(33, 10)];
    
    _protocalLabel.attributedText = attrStr;
    
    [_protocalLabel yb_addAttributeTapActionWithStrings:@[@"《个人信用贷款合同》",@"《贷吧标准化服务协议》",@"《人行征信授权协议》",] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        if (index == 0) {
            [self pushToWebViewWithUrlStr:[NSString stringWithFormat:@"%@?uid=%@&token=%@&money=%.2f&channel_key=hjr_app",loansPactProtocolURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken],self.loanMoney] title:@"个人信用贷款合同"];
        }else if (index == 1){
            [self pushToWebViewWithUrlStr:[NSString stringWithFormat:@"%@?uid=%@&token=%@&money=%.2f&channel_key=hjr_app",serveProtocolURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken],self.loanMoney] title:@"贷吧标准化服务协议"];
        }else{
            [self pushToWebViewWithUrlStr:[NSString stringWithFormat:@"%@?uid=%@&token=%@&channel_key=hjr_app",creditAccreditURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]] title:@"人行征信授权协议"];
        }
       NSString *message = [NSString stringWithFormat:@"点击了“%@”字符\nrange: %@\nindex: %ld",string,NSStringFromRange(range),index];
        DDLog(@"messager == %@",message);
    }];
    //设置是否有点击效果，默认是YES
    _protocalLabel.enabledTapEffect = NO;

}
//获取借款用途
-(void)requestLoanUseData {
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    //借款期限
    if (_dateNum) {
         [param setObject:_dateNum forKey:@"borrow_day"];
    }
    [[HttpManger sharedInstance]callHTTPReqAPI:getBorrowConfigURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        // 借款用途
        self.loanUseArr = [LoanUseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"pur"]];
         // 银行卡
        self.bankModel = [BankModel mj_objectWithKeyValues:responseObject[@"data"][@"bank"]];
        // 是否设置了支付密码
        self.isSetPayPassword = responseObject[@"data"][@"is_set"];
        //平台服务费
        self.platform_rate =  [NSString isEmptyString:[responseObject[@"data"][@"platform_rate"] stringValue]] ? @0  : responseObject[@"data"][@"platform_rate"];
        //刷新界面
        [self reloadViewWithData];
    }];
}
-(void)reloadViewWithData{
     _setPayScrectBtn.hidden  = self.isSetPayPassword.integerValue;
    _tipLabel.text = [NSString stringWithFormat:@"借款到账后，将收取%.1f%%平台服务费",[self.platform_rate  floatValue] * 100];
    
    [_cardImgView sd_setImageWithURL:[NSURL URLWithString:self.bankModel.small_icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cardNameLabel.text = [NSString stringWithFormat:@"%@(%@)",self.bankModel.bank_name,self.bankModel.bank_account];
    //增加银行卡查看的方法
    [YMTool addTapGestureOnView:_cardNameLabel target:self selector:@selector(changeCardClick:) viewController:self];
}
#pragma mark - 借款按钮点击啦
- (IBAction)usrDetailClick:(id)sender {
    [_useTextFd becomeFirstResponder];
}
- (IBAction)psBtnClick:(id)sender {
    DDLog(@"设置借款密码");
    YMPaySecrectController* yvc = [[YMPaySecrectController alloc]init];
    yvc.refreshStateBlock = ^(BOOL isSet,NSString* password){
        if (isSet == YES) {
            _setPayScrectBtn.hidden = YES;
            _passwdFd.text = password;
        }
    };
     yvc.title = @"设置借款密码";
    [self.navigationController pushViewController:yvc animated:YES];

}
- (IBAction)protocalBtnClick:(UIButton*)sender {
    sender.selected = !sender.selected;
}
- (IBAction)codeBtnClick:(id)sender {
    DDLog(@"获取验证码");
    //
    [_codeTextFd becomeFirstResponder];
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kPhone] forKey:@"phone"];
    //立即借款
    [param setObject:@"42" forKey:@"tpl_id"];
    
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

- (IBAction)loanBtnClick:(id)sender {
     DDLog(@"立即借款");
    if (_useTextFd.text.length == 0) {
        [MBProgressHUD showFail:@"请输入借款用途！" view:self.view];
        return;
    }
    if (_passwdFd.text.length < 6 || _passwdFd.text.length > 12) {
        [MBProgressHUD showFail:@"借款密码不正确，请重新输入！" view:self.view];
        return;
    }
    if (_codeTextFd.text.length < 6 ) {
        [MBProgressHUD showFail:@"验证码不正确，请重新输入！" view:self.view];
        return;
    }
    if (self.loanMoney <= 0) {
        [MBProgressHUD showFail:@"最小借款金额为100元!" view:self.view];
        return;
    }
    
    NSString* usrCode;
    for (LoanUseModel* model in self.loanUseArr) {
        if ([model.name isEqualToString:_useTextFd.text]) {
            usrCode = model.code;
        }
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    //借钱金额
    [param setObject:@(self.loanMoney).stringValue forKey:@"borrow_money"];
    //借款用途
    [param setObject:usrCode forKey:@"borrow_use"];
    //借款密码
    [param setObject:[RSAEncryptor encryptString:_passwdFd.text publicKey:kPublicKey] forKey:@"borrow_passwd"];
    //网络
    [param setObject: [YMTool getNetWorkStates] forKey:@"network"];
    if ([YMTool deviceModel]) {
        //手机型号
        [param setObject:[YMTool deviceModel] forKey:@"mobile_brand"];
    }else{
         [param setObject:[YMTool deviceModel] forKey:@"iphone"];
    }

    [param setObject:_codeTextFd.text forKey:@"captcha"];
    //借款天数 默认30 天
    if ( [NSString isEmptyString:_dateNum]) {
        _dateNum = @"30";
    }
    [param setObject:_dateNum forKey:@"borrow_day"];
    [param setObject:@(_protocalBtn.selected).stringValue forKey:@"agree"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    
    [[HttpManger sharedInstance]callHTTPReqAPI:borrowMoneyURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        [MBProgressHUD showSuccess:responseObject[@"msg"] view:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}
- (IBAction)forgetBtnClick:(id)sender {
    DDLog(@"忘记密码");
    if (self.isSetPayPassword.integerValue == 0) {
        YMPaySecrectController* yvc = [[YMPaySecrectController alloc]init];
        yvc.title = @"设置借款密码";
        yvc.refreshStateBlock = ^(BOOL isSet, NSString *password) {
            if (isSet == YES) {
                _setPayScrectBtn.hidden = YES;
            }
        };
        [self.navigationController pushViewController:yvc animated:YES];
    }else{
        YMModifySecrectPsController* yvc = [[YMModifySecrectPsController alloc]init];
        yvc.title = @"忘记借款密码";
        [self.navigationController pushViewController:yvc animated:YES];
    }
}
- (IBAction)changeCardClick:(id)sender {
    DDLog(@"切换借款银行卡");
    //[self pushToWebViewWithUrlStr:bankHelpCenterURL title:@"帮助中心"];
    YMBankCardListController* yvc = [[YMBankCardListController alloc]init];
    yvc.title = @"我的银行卡";
    [self.navigationController pushViewController:yvc animated:YES];
}
- (IBAction)helpBtnClick:(id)sender {
    DDLog(@"疑问");
    [self pushToWebViewWithUrlStr:calculatorURL title:@"费率计算"];
}

//跳转到网页
-(void)pushToWebViewWithUrlStr:(NSString* )urlStr title:(NSString* )title{
    YMWebViewController* yvc = [[YMWebViewController alloc]init];
    yvc.title = title;
    yvc.urlStr = urlStr;
    [self.navigationController pushViewController:yvc animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.useTextFd) {
        NSMutableArray* tmpArr = [[NSMutableArray alloc]init];
        for (LoanUseModel* usrModel in self.loanUseArr) {
            [tmpArr addObject:usrModel.name];
        }
        //选择用途列表
        SelectPickerView* svc = [[SelectPickerView alloc]init];
        svc.delegate = self;
        svc.type = @"bank";
        svc.allData = @[tmpArr];
        self.useTextFd.inputView = svc;
        DDLog(@"key == %@",self.loanUseArr);
    }
    //设置密码
    if (textField == self.passwdFd) {
        if (self.isSetPayPassword.integerValue == 0) {
            
            [self psBtnClick:nil];
            return NO;
        }
    }
    return YES;
}

//滚动自动调用
- (void)pickerView:(UIPickerView *)pickerView changeValue:(NSDictionary *)param{
    DDLog(@"param == %@",param);
    [self setValueWithParam:param];
}
//点击确定按钮
- (void)pickerView:(UIPickerView *)pickerView doneValue:(NSDictionary *)param{
    DDLog(@"param == %@",param);
    [self.view endEditing:YES];
    [self setValueWithParam:param];
}

//点击取消按钮
- (void)pickerView:(UIPickerView *)pickerView cancelValue:(NSDictionary*)param{
    [self.view endEditing:YES];
    DDLog(@"param == %@",param);
}
// 给界面赋值
-(void)setValueWithParam:(NSDictionary* )param {
    if ([param[@"type"] isEqualToString:@"bank"]) {
        self.useTextFd.text = param[@"component0"];
    }
}

#pragma mark - 验证吗
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
        [_codeBtn setTitleColor:DefaultNavBarColor forState:UIControlStateNormal];
        _totalTime = 60;
        //先停止，然后再某种情况下再次开启运行timer
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
    }
}

//-(void)strClick:(UITapGestureRecognizer* )tap{
//    DDLog(@"tapView == %@ tap == %@",tap.view,tap);
//
//}
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    return YES;
//}
//
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
//
//    return YES;
//}
//-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
//
//     DDLog(@"characterRange length == %lu location == %lu URL == %@",(unsigned long)characterRange.length,(unsigned long)characterRange.location,URL);
//
//
//    return YES;
//}
//- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
//
//     DDLog(@"characterRange length == %lu location == %lu URL == %@",(unsigned long)characterRange.length,(unsigned long)characterRange.location,textAttachment);
//
//    return YES;
//}

@end
