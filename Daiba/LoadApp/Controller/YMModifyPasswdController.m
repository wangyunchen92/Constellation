//
//  YMModifyPasswdController.m
//  CloudPush
//
//  Created by YouMeng on 2017/4/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMModifyPasswdController.h"

@interface YMModifyPasswdController ()
//原密码
@property (weak, nonatomic) IBOutlet UITextField *orignalTextFd;

@property (weak, nonatomic) IBOutlet UITextField *newsPassWdTextFd;
@property (weak, nonatomic) IBOutlet UITextField *secondPassWdTextFd;

//确定按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

//最大位数
@property(nonatomic,assign)NSInteger maxCount;

@end

@implementation YMModifyPasswdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _maxCount = 16;
    //监听字体处理按钮颜色
    _sureBtn.enabled = [_orignalTextFd.text length] > 0 && [_newsPassWdTextFd.text length] > 0 && [_secondPassWdTextFd.text length] > 0 ;
    _sureBtn.backgroundColor = _sureBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;
    //登陆按钮
    [YMTool viewLayerWithView:_sureBtn cornerRadius:4 boredColor:ClearColor borderWidth:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    _sureBtn.enabled = [_orignalTextFd.text length] > 0 && [_newsPassWdTextFd.text length] > 0 && [_secondPassWdTextFd.text length] > 0 ;
    _sureBtn.backgroundColor = _sureBtn.enabled ? NavBarTintColor :NavBar_UnabelColor;

    NSString *toBeString = _newsPassWdTextFd.text;
    NSString *lang       = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_newsPassWdTextFd markedTextRange];       //获取高亮部分的range
        //获取高亮部分的从range.start位置开始，向右偏移0所得的字符所在的位置。如果高亮部分不存在，那么就返回nil，反之就不是nil
        UITextPosition *position = [_newsPassWdTextFd positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxCount) {
                _newsPassWdTextFd.text = [toBeString substringToIndex:self.maxCount];
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
            _newsPassWdTextFd.text = [toBeString substringToIndex:self.maxCount];
        }
    }
}

- (IBAction)sureBtnClick:(id)sender {
    DDLog(@"确定按钮点击啦");
    if (_newsPassWdTextFd.text.length < 6   || _newsPassWdTextFd.text.length > 16 ||
        _orignalTextFd.text.length < 6      || _orignalTextFd.text.length > 16    ||
        _secondPassWdTextFd.text.length < 6 || _secondPassWdTextFd.text.length > 16) {
        [MBProgressHUD showFail:@"密码格式为6-16位数字或字母，请重新输入！" view:self.view];
        return;
    }
    if (![_newsPassWdTextFd.text isEqualToString:_secondPassWdTextFd.text]) {
        [MBProgressHUD showFail:@"两次输入的新密码不一致，请重新输入！" view:self.view];
        return;
    }
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
     [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];//
     [param setObject:_newsPassWdTextFd.text forKey:@"passwd"];
     [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"ssotoken"];
    [[HttpManger sharedInstance]callHTTPReqAPI:updatePasswordURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        //登陆接口
        YMLoginController* lvc = [[YMLoginController alloc]init];
        
        [weakSelf.navigationController pushViewController:lvc animated:YES];
    }];
    
}

@end
