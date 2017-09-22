//
//  URLs.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/22.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#ifndef URLs_h
#define URLs_h


#define SUCCESS         @"200"
#define FAILURE         @"0"
#define TOKEN_TIMEOUT   @"-1"
#define UPDATE_VERSION          @"301"
#define FAILURE_TOKEN   @"API_FAILURE_TOKEN"

#define Version          @"3"
#define app_version     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//  [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"]


#define  BaseApi        @"https://www.hjr.com/" //  @"https://dk.youmeng.com/"  //


//注册
#define RegisterURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"api/member/register"]
//账户密码 登陆
#define LoginURL            [NSString stringWithFormat:@"%@%@",BaseApi,@"api/member/login"]
//修改密码
#define updatePasswordURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/member/updatePasswd"]
//手机验证   验证码类型 37表示登陆 38表示注册 39表示修改密码
#define  SendMsgCodeURL      [NSString stringWithFormat:@"%@%@",BaseApi,@"api/member/sendSmsCode"]
//忘记密码 设置密码
#define  ForgetSetPasswdURL  [NSString stringWithFormat:@"%@%@",BaseApi,@"api/member/findPasswd"]

//申请银行卡绑定
#define applyBankCardURL  [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Member/applyCard"]

//自拍 录象
#define uploadVideoURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Account/apply"]
//用户开户信息
#define getAccountInfoURL  [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Account/getAccountInfo"]
//上传身份证信息
#define accountApplyURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Account/apply"]
//绑定银行卡列表
#define bankListURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Account/getBankInfo"]
//申请开户
#define applyAccountURL  [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Account/apply"]

//上传通讯录
#define updatePhoneURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Account/uploadPhone"]
//获取用户认证信息
#define getCreditListURL [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Credit/getCreditList"]
//获取芝麻信用授权
#define getZmxyAuthURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Member/getZmxyAuthUrl"]
//手机认证
#define getMobileURL     [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Member/getMobile"]

//日志上报url
#define LogReportURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Log/IosStart"]


// --------------  订单协议
//贷吧 个人信用贷款合同
#define loansPactProtocolURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Protocol/loansPact"]
//贷吧 人行征信授权协议
#define creditAccreditURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Protocol/creditAccredit"]
//贷吧标准化服务协议 (借款流程)
#define serveProtocolURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Protocol/serveProtocol"]
//--------------- 开户协议
//贷吧 个人信用报告查询授权书
#define creditQueryAccreditURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Protocol/creditQueryAccredit"]
//贷吧 标准化服务协议（开户审核流程）
#define accountProtocolURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Protocol/accountProtocol"]
//注册协议
#define RegistProtocalURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Protocol/regProtocol"]

// -------------- 网页链接
//费率计算
#define calculatorURL           [NSString stringWithFormat:@"%@%@",BaseApi,@"Static/Help/calculator.html"]
//手机运营商 授权
#define authenticationURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Static/Help/authentication.html"]
//帮助中心
#define bankHelpCenterURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Static/Help/help-center.html"]
//地址规范
#define addressStandardURL      [NSString stringWithFormat:@"%@%@",BaseApi,@"Static/Help/standard.html"]


//获取用户借款信息 开户状态 订单状态
#define getUsrStatusURL     [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Member/getUserStatusInfo"]
//获取配置信息
#define getConfigInfoURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Member/getConfigInfo"] 


//获取用户借款信息 开户状态 订单状态
#define getBorrowConfigURL     [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Pay/getBorrowConfig"]
//设置借款密码
#define setBorrowPswdURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Pay/setBorrowPasswd"]
//修改支付密码
#define updateBorrowPswdURL  [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Pay/updateBorrowPasswd"]
//立即借款
#define borrowMoneyURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Pay/borrowMoney"]
//立即还款
#define backMoneyURL     [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Pay/backMoney"]

//历史订单
#define  HistoryListURL  [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Member/historyOrder"]

//帮助中心
#define HelpListURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Help/getHelpList"]
//帮助详情
#define HelpInfoURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"api/Help/getHelpInfo"]



















//请求首页数据
#define HomeDataURL        [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/home"]
//修改 绑定 手机
#define UpdatePhoneURL     [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/Site/updatePhone"]
//快捷登陆
#define QuickLoginURL      [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/Site/quickLogin"]

//关于我们
#define AboutUsURL              @"http://sdd.youmeng.com/about.html"
//忘密码 图形验证码
#define ForgetImgCodeCheckURL   @"http://passport.youmeng.com/find/checkfindcaptcha"


//分享logo 的链接
#define shareLogoURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"static/images/share_logo@2x.png"]

//上传头像
#define uploadUserPicURL      [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/upload_pic_interface/upload"]
//提现明细
#define ExtractRecordListURL  [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/ExtractRecord"]
//余额明细
#define ChangeMoneyLogURL      [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/ChangeMoneyLog"]
//待发明细
#define WaitingListURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/WaitingList"]
//用户反馈 意见反馈接口
#define SuggestListURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/SuggestionList"]

//红包列表接口
#define RedPaperListURL      [NSString stringWithFormat:@"%@%@",BaseApi,@"Redpaper/index"]

//任务列表
#define  TaskListURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list"]
//任务详情
#define  TaskDetailURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_details"]
//立即接单 -- 羊头pc接单
#define  TaskReciveURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/my_task_list"]


//参与记录列表
#define AuditListURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/auditList/index"]

//项目详情
#define ProductDetailURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"PlatformDetails/index"]
//合作人明细
#define InviteFriendsURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"InviteFriends/home"]
//签到页面
#define UserSignListURL     [NSString stringWithFormat:@"%@%@",BaseApi,@"usersign/sign_list"]

//我的任务列表 待处理
#define MyTaskListPending      [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_pending"]

//我的任务列表  审核中
#define MyTaskListAudit        [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_audit"]
//我的任务列表  审核成功
#define MyTaskListSuccess      [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_success"]
//我的任务列表  已失效
#define MyTaskListFailed       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_failed"]
//我的任务 放弃任务
#define AuditMyTaskURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/task_list/task_audit_status"]

//我的钱包 信息
#define UserPayInfoURL         [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/member/UserPay/GetUserPayinfo"]

//绑定 修改 支付宝 银行卡
#define AddBankCardURL        [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/member/UserPay/FirstAddPayAccount"]

// 设置 修改支付密码
#define SetPassWordURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/member/UserPay/FirstSetUserPayPass"]
//支付密码 验证手机号
#define  CheckPwdCaptchaURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/sms_interface/check_reset_pwd_captcha"]

//支付宝 验证手机号
#define  CheckAliCaptchaURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/sms_interface/check_reset_alipay_captcha"]

//提现接口
#define GetWithdrawMoneyURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/member/UserPay/getWithdrawMoney"]
//消息列表
#define MessageListURL    [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/message_list/index"]
//消息详情
#define MessageDetailURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/message_list/message_details"]
//删除消息
#define MessageDeleteURL   [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/message_list/delUserMessage"]
//阅读消息
#define MessageReadURL     [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/message_list/message_read"]

//修改密码 密保手机  短信验证
//#define ValidateMsgURL       [NSString stringWithFormat:@"%@%@",BaseApi,@"Api/Sms_interface/validate"]
//忘记密码 短信验证
//#define ForgetCheckPhoneURL     @"http://passport.youmeng.com/find/checkphonecaptcha"
//找回密码获取验证码
//#define ForgetSendCodeURL       @"http://passport.youmeng.com/find/sendphonecaptcha"
#endif /* URLs_h */
