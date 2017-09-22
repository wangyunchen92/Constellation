//
//  YMPhoneIdentifyController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/14.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMPhoneIdentifyController.h"

//以下需要修改为您平台的信息
//启动SDK必须的参数
//Apikey,您的APP使用SDK的API的权限
#define theApiKey @"33103a80-d116-492b-82a9-55986f40a0b4"
//用户ID,您APP中用以识别的用户ID
#define theUserID @"107023"

@interface YMPhoneIdentifyController ()

@end

@implementation YMPhoneIdentifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // [self configMoxieSDK];
 
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    //    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}
/**********************SDK 使用***********************/
//-(void)configMoxieSDK{
//    /***必须配置的基本参数*/
//    [MoxieSDK shared].delegate = self;
//    [MoxieSDK shared].mxUserId = theUserID;
//    [MoxieSDK shared].mxApiKey = theApiKey;
//    [MoxieSDK shared].fromController = self;
//    [MoxieSDK shared].hideRightButton = YES;
//    // 主题色定义
//    [MoxieSDK shared].themeColor = HEX(@"ff5800");
//    //协议入口文字 -- 默认 导航
//    [MoxieSDK shared].useNavigationPush = YES;
//    //登陆验证成功后即退出，默认为NO
//    [MoxieSDK shared].quitOnLoginDone = YES;
//    [MoxieSDK shared].backImageName = @"back";
//    
//    //-------------更多自定义参数，请参考文档----------------//
//};

#pragma MoxieSDK Result Delegate
//-(void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary{
//    int code = [resultDictionary[@"code"] intValue];
//    NSString *taskType = resultDictionary[@"taskType"];
//    NSString *taskId = resultDictionary[@"taskId"];
//    NSString *searchId = resultDictionary[@"searchId"];
//    NSString *message = resultDictionary[@"message"];
//    NSString *account = resultDictionary[@"account"];
//    NSLog(@"get import result---code:%d,taskType:%@,taskId:%@,searchId:%@,message:%@,account:%@",code,taskType,taskId,searchId,message,account);
//    //用户没有做任何操作
//    if(code == -1){
//        NSLog(@"用户未进行操作");
//    }
//    //假如code是2则继续查询该任务进展
//    else if(code == 2){
//        NSLog(@"任务进行中，可以继续轮询");
//    }
//    //假如code是1则成功
//    else if(code == 1){
//        NSLog(@"任务成功");
//    }
//    //该任务失败按失败处理
//    else{
//        NSLog(@"任务失败");
//    }
//    NSLog(@"任务结束，可以根据taskid，在租户管理系统查询该次任何的最终数据，在魔蝎云监控平台查询该任务的整体流程信息。SDK只会回调状态码及部分基本信息，完整数据会最终通过服务端回调。（记得将本demo的apikey修改成公司对应的正确的apikey）");
//}

/**********************打开SDK Demo***********************/
/* taskType 为
 * email：邮箱 bank：网银 insuarnce：车险保单 fund：公积金
 * alipay：支付宝 jingdong：京东 taobao：淘宝 carrier 运营商
 * qq：腾讯QQ maimai:脉脉 linkedin:领英（LinkedIn） chsi:学信网
 * zhengxin:征信报告 tax：个人所得税 security：社保
 */

/**
 *  loginCustom参数见文档第四个条目，默认不传时为打开该功能默认界面。
 */
//运营商导入
//- (void)carrierImportClick{
//    [MoxieSDK shared].taskType = @"carrier";
//    //自定义运营商
//    [MoxieSDK shared].carrier_phone    = [kUserDefaults valueForKey:kPhone];
//    //[MoxieSDK shared].carrier_password = @"123456";
//    [MoxieSDK shared].carrier_name   = [kUserDefaults valueForKey:kCard_realName];
//    [MoxieSDK shared].carrier_idcard = [kUserDefaults valueForKey:kIDNum];
//    
//    [[MoxieSDK shared] startFunction];
//}
////征信导入
//-(void)zhengxinImportClick{
//    [MoxieSDK shared].taskType = @"zhengxin";
//    //打开征信v2版本
//    [MoxieSDK shared].loginVersion = @"v2";
//    [[MoxieSDK shared] startFunction];
//}
////个税导入
//-(void)taxImportClick{
//    [MoxieSDK shared].taskType = @"tax";
//    [[MoxieSDK shared] startFunction];
//}
////社保导入
//-(void)securityImportClick{
//    [MoxieSDK shared].taskType = @"security";
//    [[MoxieSDK shared] startFunction];
//}


@end
