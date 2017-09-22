//
//  YMApplyMainController.m
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMApplyMainController.h"
#import "YMIdentityCell.h"
#import "YMBankCardCell.h"
#import "YMRelationCell.h"
#import "YMAddressCell.h"
#import "YMHeadIdendityCell.h"

#import "YMIdentityController.h"
#import "YMRelationController.h"
#import "YMAddressController.h"
#import "YMVideoInfoController.h"
#import "YMBankCardController.h"
#import "YMPhoneIdentifyCell.h"  //手机号认证

#import "AddressModel.h"
#import "AddressBookModel.h"
#import "BankModel.h"
#import "PhotoModel.h"
#import "IdCardModel.h"

#import "YMBankUnsetCell.h"
#import "YMLoanProtocalController.h"
#import "YMWebViewController.h"
#import "YMTabBarController.h"
#import "YMWarnView.h"

#import "YMDateTool.h"

#import "CustomDetectViewController.h"
#import <MGBaseKit/MGBaseKit.h>
#import <MGLivenessDetection/MGLivenessDetection.h>
#import "UIButton+Detect.h"
#import "CustomDetectViewController.h"


@interface YMApplyMainController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)YMIdentityCell* identityCell;
@property(nonatomic,strong)YMWarnView* warnView;

//审核中的值
@property(nonatomic,strong)NSDictionary* accountCheckDic;
@property(nonatomic,strong)IdCardModel* idModel;
@property(nonatomic,strong)PhotoModel*  photoModel;
@property(nonatomic,strong)BankModel*  bankModel;
@property(nonatomic,strong)AddressBookModel* addrsBookModel;
@property(nonatomic,strong)AddressModel* addrsModel;
@property(nonatomic,strong)NSNumber*  mobile_credit;//手机认证
@property(nonatomic,strong)id face;


//同意协议
@property (weak, nonatomic) IBOutlet UIButton *protocalBtn;
//协议
@property (weak, nonatomic) IBOutlet UILabel *protocalLabel;
@property(nonatomic,strong)YMLoanProtocalController * protocalVC;

@end

@implementation YMApplyMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.checkStep integerValue] > 0 ) {
        YMWarnView * warnView = [YMWarnView shareViewWithIconStr:@"感叹" warnStr: [NSString stringWithFormat:@"请修改第%@步资料，重新提交审核",self.checkStep] tapBlock:^(UILabel *label) {

        }];
        warnView.height = 35;
        warnView.warnLabel.textColor = RedColor;
        warnView.warnLabel.font = Font(13);
        self.warnView = warnView;
    }
    self.tableView.tableFooterView = [UIView new];
    //请求账号信息
    [self requestAccountInfo];
    //修改界面
    [self modifyView];
   
}
-(void)modifyView {
    [YMTool labelColorWithLabel:_protocalLabel font:Font(14) range:NSMakeRange(2, _protocalLabel.text.length - 2) color:BlueBtnColor];
    [YMTool addTapGestureOnView:_protocalLabel target:self selector:@selector(showProtocal:) viewController:self];
    
    YMWeakSelf;
    _protocalVC = [YMLoanProtocalController new];
    _protocalVC.tapBlock = ^(SectionHeadCell *cell) {
        DDLog(@"点击啦 cell == %@",cell.titlLabel.text);
        YMWebViewController* yvc = [[YMWebViewController alloc]init];
        switch (cell.tag) {
            case 0:
                yvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&token=%@&channel_key=hjr_app",creditQueryAccreditURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
                break;
            case 1:
                yvc.urlStr = [NSString stringWithFormat:@"%@?uid=%@&token=%@&channel_key=hjr_app",accountProtocolURL,[kUserDefaults valueForKey:kUid],[kUserDefaults valueForKey:kToken]];
                break;
            default:
                break;
        }
        yvc.title = cell.titlLabel.text;
        [weakSelf.navigationController pushViewController:yvc animated:YES];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:_protocalVC.view];
    _protocalVC.view.hidden = YES;
    //返回按钮
    self.navigationItem.leftBarButtonItem =  [UIBarButtonItem backItemWithImageNamed:@"back" title:nil target:self action:@selector(back)];

}
-(void)back {
    if (self.isNext == YES || self.checkStep.integerValue > 0 ) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        YMTabBarController* tab = [[YMTabBarController alloc]init];
        [self presentViewController:tab animated:YES completion:nil];
    }
}
#pragma mark - 网络请求 查询开户信息
-(void)requestAccountInfo {
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    [param setObject:@"all" forKey:@"info_type"];
    //渠道
    [[HttpManger sharedInstance]callHTTPReqAPI:getAccountInfoURL params:param view:self.view loading:YES tableView:self.tableView completionHandler:^(id task, id responseObject, NSError *error) {
        
        NSDictionary* resData = responseObject[@"data"];
        self.accountCheckDic  = resData[@"account"];
        self.addrsModel = [AddressModel mj_objectWithKeyValues:resData[@"address"]];
        self.addrsBookModel = [AddressBookModel mj_objectWithKeyValues:resData[@"book"]];
        self.bankModel = [BankModel mj_objectWithKeyValues:resData[@"bank"]];
        self.idModel = [IdCardModel mj_objectWithKeyValues:resData[@"card"]];
        //人脸识别
        self.face = resData[@"face"];
        if (![NSString isEmptyString:self.idModel.real_name]) {
            [kUserDefaults setObject:self.idModel.real_name forKey:kRealName];
            [kUserDefaults setObject:self.idModel.card_number forKey:kIDNum];
            [kUserDefaults synchronize];
        }
        self.photoModel = [PhotoModel mj_objectWithKeyValues:resData[@"photo"]];
        //手机认证
        self.mobile_credit = resData[@"mobile_credit"];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            //身份证识别
            return 50;
            break;
        case 1:
            //人脸识别
            return 50;
            break;
        case 2:
            //银行卡
            return 88;
            break;
        case 3:
            //基本信息 居住地址
            return 205;
            break;
        case 4:
            //通讯录
            return 140;
            break;
        case 5:
            //手机认证
            return 50;
            break;
        default:
            return 0;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.checkStep.integerValue > 0) {
             return 40;
        }
        return 0;
    }
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UIView* )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if ([self.checkStep integerValue] > 0) {
            return  self.warnView;
        }
        return nil;
    }else{
        return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMWeakSelf;
    switch (indexPath.section) {
        case 0:
        {
             YMIdentityCell* cell  = [YMIdentityCell shareCellWithModifyBlock:^(UIButton *btn) {
                 YMIdentityController* yvc = [[YMIdentityController alloc]init];
                 yvc.title = @"个人身份证";
                //__weak YMIdentityCell* weakCell = cell;
                 yvc.idInfoBlock = ^(IDInfo* idModel){
                      weakSelf.identityCell.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",idModel.name];
                      weakSelf.identityCell.idNumLabel.text = [NSString stringWithFormat:@"姓名：%@",idModel.num];
                     DDLog(@"idModel  name == %@  num == %@",idModel.name,idModel.num);
                 };
                 IDInfo* idIfo = [[IDInfo alloc]init];
                 idIfo.num = self.idModel.card_number;
                 idIfo.name = self.idModel.real_name;
                 
                 idIfo.checkStatus = [self.accountCheckDic[@"check1"] boolValue];
                 //当 人脸识别认证 或 绑定了银行卡 身份证不可编辑
                 if (![NSString isNull:self.face] || ![NSString isNull:self.bankModel]) {
                     idIfo.checkStatus = YES;
                 }
                 yvc.idInfoModel = idIfo;
                 yvc.isHaveImage = YES;
                 [weakSelf.navigationController pushViewController:yvc animated:YES];
            }];
            self.identityCell = cell;
            //赋值
            cell.idcardModel = self.idModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
            //活体检测
            YMPhoneIdentifyCell* cell = [YMPhoneIdentifyCell shareCell];
           // if ([NSString isNull:self.face]) {
                cell.titlLabel.text = [NSString stringWithFormat:@"人脸识别%@",[NSString isNull:self.face] ? @"尚未认证" : @"已认证"];
           // }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:
        {
            if (![NSString isEmptyString:self.bankModel.bank_account]) {
                YMBankCardCell* cell = [YMBankCardCell shareCellWithModifyBlock:^(UIButton *btn) {
                    YMBankCardController* yvc = [[YMBankCardController alloc]init];
                    yvc.title = @"修改银行卡";
                    yvc.bankModel = weakSelf.bankModel;
                    yvc.refreshBlock = ^(){
                        [weakSelf requestAccountInfo];
                    };
                    yvc.isCheckStatus = [self.accountCheckDic[@"check2"] boolValue];
                    [weakSelf.navigationController pushViewController:yvc animated:YES];
                }];
                cell.bankModel = self.bankModel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }else{
                YMBankUnsetCell* cell = [YMBankUnsetCell shareCellWithBlock:^(UIButton *btn) {
                    YMBankCardController* yvc = [[YMBankCardController alloc]init];
                    yvc.title = @"绑定银行储蓄卡";
                    yvc.refreshBlock = ^(){
                        [weakSelf requestAccountInfo];
                    };
                    [weakSelf.navigationController pushViewController:yvc animated:YES];
                }];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
        case 3:
        {
            YMAddressCell* cell = [YMAddressCell shareCellWithModifyBlock:^(UIButton *btn) {
                YMAddressController* yvc = [[YMAddressController alloc]init];
                yvc.title = @"基本信息";
                yvc.refreshBlock = ^(){
                    [weakSelf requestAccountInfo];
                };
                yvc.addrsModel = weakSelf.addrsModel;
                [weakSelf.navigationController pushViewController:yvc animated:YES];
            }];
             cell.addrsModel = self.addrsModel;
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 4:
        {
            YMRelationCell* cell = [YMRelationCell shareCellWithModifyBlock:^(UIButton *btn) {
                YMRelationController* yvc = [[YMRelationController alloc]init];
                yvc.title = @"紧急联系人";
                yvc.addresBookModel = weakSelf.addrsBookModel;
                yvc.refreshBlock = ^{
                    [weakSelf  requestAccountInfo];
                };
                [weakSelf.navigationController pushViewController:yvc animated:YES];
            }];
             cell.addresBookModel = self.addrsBookModel;
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 5:
        {
            YMPhoneIdentifyCell* cell = [YMPhoneIdentifyCell shareCell];
            NSTimeInterval nowTime = [[NSDate date]timeIntervalSince1970];
            long pastTime = [[kUserDefaults valueForKey:kSetPhoneDate] longValue];
            //不足 5分钟
            if (self.mobile_credit.integerValue == 0) {
                if (nowTime - pastTime < 0) {
                    cell.titlLabel.text = @"手机认证中";
                }else{
                    cell.titlLabel.text = [NSString stringWithFormat:@"手机未认证"];
                   
                }
            }else{
                if(self.mobile_credit.integerValue == 3){
                    cell.titlLabel.text = @"手机认证已过期";
                }
                if(self.mobile_credit.integerValue == 4){
                    cell.titlLabel.text = @"手机认证暂未开通";
                }
                if(self.mobile_credit.integerValue == 1){
                    cell.titlLabel.text = @"手机认证已通过";
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);

            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YMWeakSelf;
    switch (indexPath.section) {
        case 0:
        {
            YMIdentityController* yvc = [[YMIdentityController alloc]init];
            yvc.title = @"个人身份证";
            yvc.idInfoBlock = ^(IDInfo* idModel){
                weakSelf.identityCell.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",idModel.name];
                weakSelf.identityCell.idNumLabel.text = [NSString stringWithFormat:@"身份证：%@",idModel.num];
                DDLog(@"idModel  name == %@  num == %@",idModel.name,idModel.num);
            };
            
            IDInfo* idIfo = [[IDInfo alloc]init];
            idIfo.num = self.idModel.card_number;
            idIfo.name = self.idModel.real_name;
            // 0  1 通过 2 (拒绝)  3
            idIfo.checkStatus = [self.accountCheckDic[@"check1"] boolValue];
            //当 人脸识别认证 或 绑定了银行卡 身份证不可编辑
            if (![NSString isNull:self.face] || ![NSString isNull:self.bankModel]) {
                idIfo.checkStatus = YES;
            }
            yvc.idInfoModel = idIfo;
            
            yvc.isHaveImage = YES;
            
            yvc.refreshBlock = ^(){
                [weakSelf requestAccountInfo];
            };
            [self.navigationController pushViewController:yvc animated:YES];
        }
            break;
        case 1:
        {
            //判断时间
            // NSDate *nowDate = [NSDate date];
            // NSDictionary *licenseDic = [MGLivenessDetector checkCachedLicense];
            //  NSDate *sdkDate = [licenseDic valueForKey:[MGLivenessDetector getVersion]];
            // if ([sdkDate compare:nowDate] == NSOrderedDescending) {
            //                /*该处表示即可正确使用活体检测 iOS SDK*/
            //
            //  }else{
            //                /*该处表示 无法使用 活体检测 iOS SDK， 具体问题请参考 3.常见问题以
            //                 及解决方案*/
            //  }
            
            if (![MGLiveManager getLicense]) {
                [MGLiveManager licenseForNetWokrFinish:^(bool License) {
                    NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"title_license", nil), License ? NSLocalizedString(@"title_success", nil) : NSLocalizedString(@"title_failure", nil)]);
                }];
                
                return;
            }
            CustomDetectViewController* customDetectVC = [[CustomDetectViewController alloc] initWithDefauleSetting];
            customDetectVC.refreshBlock = ^{
                 [weakSelf requestAccountInfo];
            };
            [self.navigationController pushViewController:customDetectVC animated:YES];
            //            YMVideoInfoController* yvc = [[YMVideoInfoController alloc]init];
            //            yvc.title = @"影像资料";
            //            yvc.refreshBlock = ^(){
            //                [weakSelf requestAccountInfo];
            //            };
            //            [self.navigationController pushViewController:yvc animated:YES];
        }
            break;
        case 2:
        {
            YMBankCardController* yvc = [[YMBankCardController alloc]init];
            if (![NSString isEmptyString:self.bankModel.bank_account]) {
                yvc.title = @"修改银行卡";
                yvc.bankModel = self.bankModel;
                yvc.refreshBlock = ^(){
                    [weakSelf requestAccountInfo];
                };
                yvc.isCheckStatus = [self.accountCheckDic[@"check2"] boolValue];
            }else{
                  yvc.title = @"绑定银行储蓄卡";
                  yvc.refreshBlock = ^(){
                        [weakSelf requestAccountInfo];
                  };
            }
            [self.navigationController pushViewController:yvc animated:YES];
        }
            break;
        case 3:
        {
            YMAddressController* yvc = [[YMAddressController alloc]init];
            yvc.title = @"基本信息";
            yvc.refreshBlock = ^(){
                [weakSelf requestAccountInfo];
            };
            yvc.addrsModel = self.addrsModel;
            [self.navigationController pushViewController:yvc animated:YES];
        }
            break;
        case 4:
        {
            YMRelationController* yvc = [[YMRelationController alloc]init];
            yvc.title = @"紧急联系人";
            yvc.refreshBlock = ^(){
                [weakSelf requestAccountInfo];
            };
            yvc.addresBookModel = self.addrsBookModel;
            [self.navigationController pushViewController:yvc animated:YES];
        }
            break;
           case 5:
        {
            DDLog(@"手机认证");
            if (self.mobile_credit.integerValue == 1) {
                [MBProgressHUD showSuccess:@"您的手机已认证通过！" view:self.view];
                return;
            }
            YMWebViewController* wvc = [[YMWebViewController alloc]init];
            wvc.urlStr = getMobileURL;
            wvc.hidesBottomBarWhenPushed = YES;
            wvc.isSecret = YES;
            wvc.title = @"手机认证";
            wvc.agreeBlock = ^(NSString *isAgree) {
                [weakSelf requestAccountInfo];
            };
            [self.navigationController pushViewController:wvc animated:YES];
        }
            break;
       default:
            break;
    }
}
//申请开户
- (IBAction)applyAccountClick:(id)sender {
    DDLog(@"申请开户");
    if (self.protocalBtn.selected == NO) {
        [MBProgressHUD showFail:@"请仔细阅读贷款相关协议，并同意！" view:self.view];
        return;
    }
    if (self.mobile_credit.integerValue == 0) {
         [MBProgressHUD showFail:@"手机未认证或认证未通过，请认证通过后再提交审核！" view:self.view];
         return;
    }
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:@"66" forKey:@"postion"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    [[HttpManger sharedInstance]callHTTPReqAPI:applyAccountURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
    
            YMTabBarController* tab = [[YMTabBarController alloc]init];
            [weakSelf presentViewController:tab animated:YES completion:nil];
    }];
}

#pragma mark - Detect failurd message
- (void)showErrorString:(MGLivenessDetectionFailedType)errorType {
    switch (errorType) {
        case DETECTION_FAILED_TYPE_ACTIONBLEND: {
       DDLog(@"message == %@",[NSString stringWithFormat:@"%@ %@\n%@", NSLocalizedString(@"key_action_live_detect", nil), NSLocalizedString(@"title_unsuccess", nil), NSLocalizedString(@"key_message_remind_complete_action", nil)]);
        }
            break;
        case DETECTION_FAILED_TYPE_NOTVIDEO: {
            DDLog(@"message == %@",[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"key_action_live_detect", nil), NSLocalizedString(@"title_unsuccess", nil)]);
        }
            break;
        case DETECTION_FAILED_TYPE_TIMEOUT: {
            DDLog(@"message == %@",[NSString stringWithFormat:@"%@ %@\n%@", NSLocalizedString(@"key_action_live_detect", nil), NSLocalizedString(@"title_unsuccess", nil), NSLocalizedString(@"key_message_time_complete_action", nil)]);
        }
            break;
        default: {
            DDLog(@"message == %@",[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"key_action_live_detect", nil), NSLocalizedString(@"title_failure", nil)]);
        }
            break;
    }
}

- (IBAction)agreeBtnClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _protocalVC.view.hidden = YES;
        _protocalVC.backgroundView.hidden = YES;
    }
}

-(void)showProtocal:(UITapGestureRecognizer* )tap{
    _protocalVC.view.hidden = !_protocalVC.view.hidden;
    _protocalVC.backgroundView.hidden = _protocalVC.view.hidden;
}

@end
