//
//  KeysUtil.h
//  CloudPush
//
//  Created by APPLE on 17/2/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#ifndef KeysUtil_h
#define KeysUtil_h


#define kJPushAppKey         @"dc4c1e1b5cacbf3ae50015ce" 
//@"2713a754e1dcce3a244a648e"//master Key // @"edc93c77b986a688329de0ec"
#define kChannel              @"App Store"
#define kIsProduct            YES

#define kUMAppKey       @"598d50c2734be4693e0014c1"
#define kBaiduKey       @"0GQKawZkRIxTNjLLUQGNzYfX"

//face++
#define kFaceAppKey     @"RtCTFV6feqlvnk8tzrtmZu-kNDAr-zif"   //@"USAdlgxi1mvb2-rsgxLNpmAXQwL6v4a9"
#define kFaceSecrect    @"a_wsb863BRtDhhD0-CxewyYfbxR16HE0"  //@"tbcwoqd0uocZPME4M1hsphHcSJP8QgKc"

//moxieSDK
#define  kMoXieApiKey    @"33103a80-d116-492b-82a9-55986f40a0b4"
#define  TimeKeyS        @""//ed969133dd0eece08b478d9478ff3c06
//@"c0ece54d37bb55493af86a47819e50fb" 使用版

#define kFirstOpen   @"firstOpen"
#define kAutoLogin   @"kAutoLogin"


#define WeChat_AppId      @"wxdcc23700247f2571"  // wx1705d06974c1200e//wxd930ea5d5a258f4f
#define WeChatAppSecrect  @"1851a8f91573e7e32700b88b1f1b2832"


#define QQ_AppId       @"1105799657"      //@"1106103020"   @"1105155505"      //   1105935609
#define QQ_Secrect     @"Uls5vAKp01O8JNhR"// @"uRGnHjSuLpuHtb0t"   //   bUfLXNbJWYH5PgLf @"KYJZQznciNcbiAs4"


#define kNotification_PartAct   @"kNotificationPartActs"

#define kNotification_Login     @"kNotificationLogin"
#define kNotification_LoginOut  @"kNotificationLoginOut"
#define kNotification_LoginStatusChanged  @"kNotificationLoginStatusChanged"

#define kNotification_UserDataChanged     @"kNotification_UserDataChanged"
#define kUserDefaults         [NSUserDefaults standardUserDefaults]

#define kPublicKey       @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCYYnvi6O8mOJxcRTsBRukgZ/b4KcCHKK4sTxV/7MZOkaU26jutR9MLgQe9vwiIkzmY8bC80YBpjT0griFJxub2ok7bCLxyLDwsNkooqv6j5qKPMKnsHtHex7J46zHO+pdhbQ4xyUqMoVGdJoDmMCIoOJPMiDQOC0ieh/NFcuBtmQIDAQAB"  //@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCYYnvi6O8mOJxcRTsBRukgZ/b4KcCHKK4sTxV/7MZOkaU26jutR9MLgQe9vwiIkzmY8bC80YBpjT0griFJxub2ok7bCLxyLDwsNkooqv6j5qKPMKnsHtHex7J46zHO+pdhbQ4xyUqMoVGdJoDmMCIoOJPMiDQOC0ieh/NFcuBtmQIDAQAB"
//系统的颜色
#define BlackColor      [UIColor blackColor]
#define WhiteColor      [UIColor whiteColor]
#define RedColor        [UIColor redColor]
#define BlueColor       [UIColor blueColor]
#define OrangeColor     [UIColor orangeColor]
#define LightGrayColor  [UIColor lightGrayColor]
#define LightTextColor  [UIColor lightTextColor]
#define ClearColor      [UIColor clearColor]
//背景色
#define BackGroundColor       RGBA(245, 245, 249, 1)// RGBA(239, 239, 244, 1)
//按钮的颜色 --- tabBar 选中的颜色
#define NavBarTintColor       RGBA(255, 109, 0, 1)   // HEX(@"ef5316")//RGBA(90, 162, 238, 1)  HEX(@"2196F3")
//不可点击颜色
#define NavBar_UnabelColor    HEX(@"bebebe")

//导航栏背景颜色
#define DefaultNavBarColor    RGBA(255, 109, 0, 1) //HEX(@"414b4d")

#define TabBarTintColor       RGBA(255, 109, 0, 1) //HEX(@"ef5316")

//默认按钮颜色
#define DefaultBtnColor        RGBA(255, 88, 0, 1) //  HEX(@"ef5316")
//默认按钮不可点击颜色
#define DefaultBtn_UnableColor    RGBA(255, 88, 0, 0.5)// HEX(@"bebebe")

//蓝色按钮字体颜色
#define BlueBtnColor             RGB(0, 145, 255)


//传入RGB三个参数，得到颜色
#define RGB(r,g,b) RGBA(r,g,b,1.f)
//那我们就让美工给出的 参数/255 得到一个0-1之间的数
#define RGBA(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEX(a)         [UIColor colorwithHexString:[NSString stringWithFormat:@"%@",a]]

//取得随机颜色
#define RandomColor RGB(arc4random()%256,arc4random()%256,arc4random()%256)
//字体大小
#define Font(a)        [UIFont systemFontOfSize:a]

//屏幕宽度
#define SCREEN_WIDTH  ([UIApplication sharedApplication].keyWindow.bounds.size.width)
#define SCREEN_HEGIHT  ([UIApplication sharedApplication].keyWindow.bounds.size.height)

#define KeyWindow      [UIApplication sharedApplication].keyWindow
//获取屏幕大小
#define kScreenSize [UIScreen mainScreen].bounds.size


// iPhone5/5c/5s/SE 4英寸 屏幕宽高：320*568点 屏幕模式：2x 分辨率：1136*640像素
#define iPhone5or5cor5sorSE ([UIScreen mainScreen].bounds.size.height == 568.0)
// iPhone6/6s/7 4.7英寸 屏幕宽高：375*667点 屏幕模式：2x 分辨率：1334*750像素
#define iPhone6or6sor7 ([UIScreen mainScreen].bounds.size.height == 667.0)
// iPhone6 Plus/6s Plus/7 Plus 5.5英寸 屏幕宽高：414*736点 屏幕模式：3x 分辨率：1920*1080像素
#define iPhone6Plusor6sPlusor7Plus ([UIScreen mainScreen].bounds.size.height == 736.0)



#define NavBarHeight      44
#define StatusHeight      20
#define NavBarTotalHeight 64
#define TabBarHeigh       48
#define TitleViewHeigh    40

#define kSessionCookie           @"sessionCookies"
#define kUserDefaults            [NSUserDefaults standardUserDefaults]
#define kYMUserInstance          [YMUserManager shareInstance]
#define kWidthRate               SCREEN_WIDTH / 375

//用户相关的key
#define kPhone       @"phone"
#define kToken       @"token"
#define kUid         @"uid"
#define kUsername    @"username"

#define kUseTime        @"useTime"
#define kBeginTime      @"beginTime"
#define kEndTime        @"endTime"

#define kLatitude      @"latitude"
#define kLongitude     @"longitude"

#define kDate           @"date"
#define kCreateTime     @"create_time"

#define kBorrowMoney    @"borrow_money"
#define kBorrowRate     @"borrow_rate"
#define kCheck1           @"check1"
#define kCheck2           @"check2"
#define kCheck3           @"check3"
#define kCheck4           @"check4"
#define kCheck5           @"check5"
#define kCreditMoney     @"credit_money"
#define kPostion         @"postion"
#define kStatus          @"status"
#define kPlatformRate    @"platform_rate"

#define kMoneyAccount       @"money_account"
#define kIsSetPaySecrect    @"isSetPayScrect"
#define kIsPhoneIdentify    @"isPhoneIdentify"

#define kSetPhoneDate        @"setPhoneDate"

//身份证照片
#define kFrontIdImg         @"frontIdPic"
#define kBackIdImg          @"backIdPic"
#define FrontIdImgFilePath   [[XCFileManager documentsDir]stringByAppendingPathComponent:@"frontIdImage.png"]
#define BackIdImgFilePath    [[XCFileManager documentsDir]stringByAppendingPathComponent:@"backIdImage.png"]

//头像 - 视频 照片
#define headImgFilePath   [[XCFileManager documentsDir]stringByAppendingPathComponent:@"headImage.png"]
#define videoImgFilePath    [[XCFileManager documentsDir]stringByAppendingPathComponent:@"videoImage.png"]
#define kHeadImage                @"headImage"
#define kVideoPreImage            @"videoImage"

//视频路径
#define kVideo                    @"video"
#define videoFilePath    [[XCFileManager documentsDir]stringByAppendingPathComponent:@"video.mp4"]

//用户姓名 和 身份证号
#define kIDNum           @"idNumber"
#define kRealName        @"realName"

#define kCheckStatus         @"checkStatus"
#define kZfb_accountName     @"zfb_accountName"
#define kCard_realName       @"isCard_realName"
#define kCard_accountName    @"isCard_accountName"
#define kPayStyle            @"payStyle"
#define kisRefresh           @"isRefresh"

#define kisFailureBackLoan   @"isFailureBackLoan"  //第一次失败还款
#define kisSuccessLoan       @"isSuccessLoan"      //第一次成功借钱成功 --- 显示我知道了
#define kisSuccessBackMoney  @"isSuccessBackMoney" //成功还款
#define kisLoginClick        @"isLoginClick"       //点击登陆了

//video
#define RECORD_MAX_TIME    15.0           //最长录制时间
#define TIMER_INTERVAL     0.05         //计时器刷新频率
#define VIDEO_FOLDER        @"videoFolder" //视频录制存放文件夹

//支付密码
#define kPasswd             @"passwd"

//static NSString *kAuthScope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";//授权域
////static NSString *kAuthOpenID = @"0c806938e2413ce73eef92cc3";
//static NSString *kAuthState = @"xxx";

//7.0以上的系统
#define IOS7      ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)
//ios 7 一下的系统
#define IOS_7    ([UIDevice currentDevice].systemVersion.doubleValue < 7.0)

#endif /* KeysUtil_h */
