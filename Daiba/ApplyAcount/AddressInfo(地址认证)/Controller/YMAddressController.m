//
//  YMAddressController.m
//  Daiba
//
//  Created by YouMeng on 2017/7/29.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMAddressController.h"
#import "YMWarnView.h"
#import "SelectPickerView.h"
#import "YMDataManager.h"
#import "YMCityModel.h"
#import "YMRelationController.h"
#import "YMApplyMainController.h"
#import "YMWebViewController.h"

@interface YMAddressController ()<SelectPickerDelegate>
@property (weak, nonatomic) IBOutlet UIView *warnView;
//居住地址
@property (weak, nonatomic) IBOutlet UITextField *homeAddTextFd;
@property (weak, nonatomic) IBOutlet UITextField *homeDetalTextFd;
//工作地址
@property (weak, nonatomic) IBOutlet UITextField *workAddTextFd;
@property (weak, nonatomic) IBOutlet UITextField *workDetailTextFd;
//单位名称 单位电话
@property (weak, nonatomic) IBOutlet UITextField *companyTextFd;
@property (weak, nonatomic) IBOutlet UITextField *companyTelTextFd;

@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@end

@implementation YMAddressController
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //修改界面
    [self modifyView];
    
    if (self.isShowNext == YES) {
        self.navigationItem.rightBarButtonItem =  [UIBarButtonItem itemWithTitle:@"第4/6步" font:Font(13) titleColor:WhiteColor target:self action:@selector(next:)];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)next:(UIButton*)nextBtn{
    YMRelationController* yvc = [[YMRelationController alloc]init];
    yvc.title = @"紧急联系人";
    yvc.isShowNext  = YES;
    [self.navigationController pushViewController:yvc animated:YES];
}
-(void)back{
    YMWeakSelf;
    [YMTool presentAlertViewWithTitle:@"温馨提示" message:@"资料尚未完整，确认放弃填写？" cancelTitle:@"返回" cancelHandle:^(UIAlertAction *action) {
        
        YMApplyMainController* yvc = [[YMApplyMainController alloc]init];
        yvc.title = @"提交资料，立即申请开户";
        [weakSelf.navigationController pushViewController:yvc animated:YES];
        
    } sureTitle:@"继续填写" sureHandle:^(UIAlertAction * _Nullable action) {
        
    } controller:self];
}
#pragma mark - UI
-(void)modifyView{
    //返回到信息主页
    if (self.isShowNext == YES) {
        self.navigationItem.leftBarButtonItem =  [UIBarButtonItem backItemWithImageNamed:@"back" title:nil target:self action:@selector(back)];
    }
    YMWeakSelf;
    // 添加提示语
    YMWarnView* warnView = [YMWarnView shareViewWithIconStr:@"感叹" warnStr:@"详细、真实的信息可加快审核，提高额度" tapBlock:^(UILabel *label) {
        DDLog(@"填写规范");
        YMWebViewController* wvc = [[YMWebViewController alloc]init];
        wvc.title = @"基本信息填写规范";
        wvc.urlStr = addressStandardURL;
        [weakSelf.navigationController pushViewController:wvc animated:YES];
    }];
    warnView.standardBtn.hidden = NO;
    warnView.detailBlock = ^(UIButton* btn){
        YMWebViewController* wvc = [[YMWebViewController alloc]init];
        wvc.title = @"基本信息填写规范";
        wvc.urlStr = addressStandardURL;
        [weakSelf.navigationController pushViewController:wvc animated:YES];
    };
    [self.warnView addSubview:warnView];
    
    [YMTool viewLayerWithView:self.updateBtn cornerRadius:5 boredColor:DefaultNavBarColor borderWidth:1 ];
    
    //选择居住地址
    SelectPickerView* svc = [[SelectPickerView alloc]init];
    svc.delegate = self;
    svc.type = @"home";
    svc.metaDataArr =  [YMDataManager addressArray];
    self.homeAddTextFd.inputView = svc;
    
    //选择居住地址
    SelectPickerView* wkVC = [[SelectPickerView alloc]init];
    wkVC.delegate = self;
    wkVC.type = @"work";
    wkVC.metaDataArr =  [YMDataManager addressArray];
    self.workAddTextFd.inputView = wkVC;
    
    if (self.addrsModel) {
        _homeAddTextFd.text = self.addrsModel.live_area;
        _homeDetalTextFd.text = self.addrsModel.live_adress;
        
        _workAddTextFd.text = self.addrsModel.work_area;
        _workDetailTextFd.text = self.addrsModel.work_adress;
        
        _companyTextFd.text = self.addrsModel.company;
        _companyTelTextFd.text = self.addrsModel.company_phone;
    }
}
#pragma mark - SelectPickerDelegate
//滚动自动调用
- (void)pickerView:(UIPickerView *)pickerView changeValue:(NSDictionary *)param{
    DDLog(@"滚动 ---- parameter===  %@",param);
    [self setValueWithDictionary:param];
}
//点击取消按钮
- (void)pickerView:(UIPickerView *)pickerView cancelValue:(NSDictionary*)param{
    [self.view endEditing:YES];
}
//点击确定按钮
- (void)pickerView:(UIPickerView *)pickerView doneValue:(NSDictionary *)param{
     [self.view endEditing:YES];

     [self setValueWithDictionary:param];
}
- (void)setValueWithDictionary:(NSDictionary* )param{
    if ([param[@"type"] isEqualToString:@"home"]) {
        self.homeAddTextFd.text = [NSString stringWithFormat:@"%@ %@ %@",param[@"component0"],param[@"component1"],param[@"component2"]];
    }
    if ([param[@"type"] isEqualToString:@"work"]) {
        self.workAddTextFd.text = [NSString stringWithFormat:@"%@ %@ %@",param[@"component0"],param[@"component1"],param[@"component2"]];
    }
}

#pragma mark - 按钮响应方法
- (IBAction)homeAddrsClick:(id)sender {
    DDLog(@"家庭地址点击了");
    //选择居住地址
    [self.homeAddTextFd becomeFirstResponder];
}
- (IBAction)workAddrsClick:(id)sender {
    //选择工作地址
    [self.workAddTextFd becomeFirstResponder];
}

- (IBAction)updateBtnClick:(id)sender {
    DDLog(@"点击了提交");
    if ([NSString isEmptyString:_homeDetalTextFd.text] || [NSString isEmptyString:_homeAddTextFd.text] ) {
        [MBProgressHUD showFail:@"请完善居住地址！" view:self.view];
        return;
    }
    if ([NSString isEmptyString:_workDetailTextFd.text] || [NSString isEmptyString:_workAddTextFd.text] ) {
        [MBProgressHUD showFail:@"请完善工作地址！" view:self.view];
        return;
    }
    if ([NSString isEmptyString:_companyTextFd.text]  ) {
        [MBProgressHUD showFail:@"请完善单位地址！" view:self.view];
        return;
    }
    if ([NSString isEmptyString:_companyTelTextFd.text]  ) {
        [MBProgressHUD showFail:@"请完善单位电话！" view:self.view];
        return;
    }
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:@"3" forKey:@"postion"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    NSArray* liveArr = [_homeAddTextFd.text componentsSeparatedByString:@" "];
    if (liveArr.count >= 2) {
        if (liveArr.count == 2) {
            [param setObject:liveArr[1] forKey:@"live_area"];//居住区县三级id
        }else{
           [param setObject:liveArr[2] forKey:@"live_area"];//居住区县三级id
        }
    }
    [param setObject:_homeDetalTextFd.text forKey:@"live_adress"];//居住信息地址
    
    NSArray* workArr = [_workAddTextFd.text componentsSeparatedByString:@" "];
    if (workArr.count >= 2) {
        if (workArr.count == 2) {
            [param setObject:liveArr[1] forKey:@"work_area"];//工作区县三级id
        }else{
            [param setObject:liveArr[2] forKey:@"work_area"];//工作区县三级id
        }
    }
   // [param setObject:_workAddTextFd.text forKey:@"work_area"];    //工作区县三级id
    [param setObject:_workDetailTextFd.text forKey:@"work_adress"];  //工作详细地址
    [param setObject:_companyTextFd.text forKey:@"company"];      //公司名称
    //渠道
//    [param setObject:@"hjr_app" forKey:@"channel_key"];
//    NSString* telStr = [NSString addStrWithOrgnalStr:_companyTelTextFd.text range:NSMakeRange(3, 1) specalStr:@"-"];
//    DDLog(@"telStr -== %@",telStr);
    
    [param setObject: [NSString addStrWithOrgnalStr:_companyTelTextFd.text range:NSMakeRange(3, 1) specalStr:@"-"]  forKey:@"company_phone"];//公司固话
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:accountApplyURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        //下一步 - 联系人
        if (weakSelf.isShowNext == YES && weakSelf.isModify == NO) {
            if (weakSelf.isModify == NO) {
                 [weakSelf next:nil];
            }else{
                YMApplyMainController* yvc = [[YMApplyMainController alloc]init];
                yvc.title = @"提交资料，立即申请开户";
                [weakSelf.navigationController pushViewController:yvc animated:YES];
            }
           
        }

        if (weakSelf.isShowNext == NO) {
            [MBProgressHUD showSuccess:@"上传成功，请等待审核！" view:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
                    if (self.refreshBlock) {
                        self.refreshBlock();
                    }
                    //回跳
                    [self.navigationController popViewControllerAnimated:YES];
                });
        }
    }];
}



@end
