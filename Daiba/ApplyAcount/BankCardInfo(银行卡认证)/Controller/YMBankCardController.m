//
//  YMBankCardController.m
//  Daiba
//  Created by YouMeng on 2017/8/3.
//  Copyright © 2017年 YouMeng. All rights reserved.

#import "YMBankCardController.h"//绑定银行卡
#import "YMWarnView.h"
#import "SelectPickerView.h"
#import "YMDataManager.h"
#import "UIBarButtonItem+HKExtension.h"
#import "YMAddressController.h"
//#import "LLPaySdk.h"
#import "YMApplyMainController.h"
#import "YMWebViewController.h"

#import "IOSOCRAPI.h"
#import "Globaltypedef.h"
#import "SCCaptureCameraController.h"
#import "ExtendButton.h"

#import "YMBankListCollectionViewCell.h"


@interface YMBankCardController ()<UITextFieldDelegate,SelectPickerDelegate,SCNavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
//警告
@property (weak, nonatomic) IBOutlet UIView *topView;
//卡号
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextFd;
//银行
@property (weak, nonatomic) IBOutlet UITextField *cardNameTextFd;
//开户城市
@property (weak, nonatomic) IBOutlet UITextField *cardCityTextFd;
//预留手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFd;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

//拍照银行卡
@property (weak, nonatomic) IBOutlet ExtendButton *cameraBtn;

//签约订单 参数
@property (nonatomic, strong) NSMutableDictionary *orderDic;

//银行列表 -- 服务电话
@property(nonatomic,strong)NSMutableArray* bankListArr;
@property(nonatomic,strong)NSMutableArray* serviceTelArr;

//支持银行列表
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//collectionHeight
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@end

@implementation YMBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加view
    [self modifyView];
    
    //银行卡列表
    [self requestBankList];

    if (self.isCheckStatus == YES) {
        _cardNumTextFd.userInteractionEnabled  = NO;
        _cardNameTextFd.userInteractionEnabled = NO;
        _cardCityTextFd.userInteractionEnabled = NO;
        _phoneTextFd.userInteractionEnabled    = NO;
    }
}

-(void)next:(UIButton* )nextBtn{
    YMAddressController* yvc = [[YMAddressController alloc]init];
    yvc.title = @"基本信息";
    yvc.isShowNext = YES;
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
-(void)modifyView{
    //返回到信息主页
    if (self.isShowNext == YES) {
        self.navigationItem.leftBarButtonItem =  [UIBarButtonItem backItemWithImageNamed:@"back" title:nil target:self action:@selector(back)];
        
         self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"第3/6步" font:Font(13) titleColor:WhiteColor target:self action:@selector(next:)];
    }
   
    [YMTool viewLayerWithView:_sureBtn cornerRadius:5 boredColor:ClearColor borderWidth:1];
    YMWarnView* warnView = [YMWarnView shareViewWithIconStr:@"感叹" warnStr:@"必须绑定本人银行储蓄卡，否则无法通过验证" tapBlock:^(UILabel *label) {
        DDLog(@"头部warnView点击啦");
    }];
    [self.topView addSubview:warnView];
   
    if (self.bankModel) {
         warnView.warnLabel.text = @"银行储蓄卡审核已通过，不可修改！";
        _cardNumTextFd.text = _bankModel.bank_account;
        _cardNameTextFd.text = _bankModel.bank_name;
        _cardCityTextFd.text = _bankModel.bank_city;
        _phoneTextFd.text  = _bankModel.bank_phone;
        _sureBtn.userInteractionEnabled = NO;
        [_sureBtn setBackgroundColor:DefaultBtn_UnableColor];
        _sureBtn.enabled = NO;
    }
    _cardNumTextFd.delegate = self;
    
    //注册单元格
    [self.collectionView registerNib:[UINib nibWithNibName:@"YMBankListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"YMBankListCollectionViewCell"];
}

#pragma mark - 请求数据
-(void)requestBankList{
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
  
    [[HttpManger sharedInstance]callHTTPReqAPI:bankListURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        NSMutableArray* tmpBankArr = [BankModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        for (BankModel* model in tmpBankArr) {
            [self.bankListArr addObject:model.name];
            [self.serviceTelArr addObject:model.phone];
        }
        //self.bankListArr   = [responseObject[@"data"] allKeys].mutableCopy;
        //self.serviceTelArr = [responseObject[@"data"] allValues].mutableCopy;

        //选择银行列表
        SelectPickerView* svc = [[SelectPickerView alloc]init];
        svc.delegate = self;
        svc.type = @"bank";
        svc.allData = @[self.bankListArr];
        self.cardNameTextFd.inputView = svc;
        
        //设置collectionHeight
        self.collectionViewHeight.constant = self.bankListArr.count/3 * 20 + 30;
        //刷新界面
        [self.collectionView reloadData];
//        DDLog(@"key == %@",self.bankListArr);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSMutableArray *)bankListArr{
    if (!_bankListArr) {
        _bankListArr = [[NSMutableArray alloc]init];
    }
    return _bankListArr;
}
-(NSMutableArray *)serviceTelArr{
    if (!_serviceTelArr) {
        _serviceTelArr = [[NSMutableArray alloc]init];
    }
    return _serviceTelArr;
}
#pragma mark - 按钮响应方法
- (IBAction)bankNameBtnClick:(id)sender {
    DDLog(@"开户银行点击啦");
    [_cardNameTextFd becomeFirstResponder];
}
- (IBAction)cardCityBtnClick:(id)sender {
    DDLog(@"开户城市点击啦");
    [_cardCityTextFd becomeFirstResponder];
}
- (IBAction)descBtnClick:(id)sender {
    DDLog(@"描述");
    YMWebViewController* yvc = [[YMWebViewController alloc]init];
    yvc.urlStr = bankHelpCenterURL;
    yvc.title  = @"帮助中心";
    [self.navigationController pushViewController:yvc animated:YES];
}

- (IBAction)sureBtnClick:(id)sender {

    if ([NSString isEmptyString:self.cardNumTextFd.text]) {
        [MBProgressHUD showFail:@"请输入银行卡号" view:self.view];
        return;
    }
    NSString* bankNum = [NSString deleteStrWithOrignalStr: _cardNumTextFd.text specailStr:@" "];
    if (![NSString isBankCard:bankNum]) {
        [MBProgressHUD showFail:@"输入的银行卡号不正确，请重新输入！" view:self.view];
        return;
    }
    if ([NSString isEmptyString:self.cardNameTextFd.text]) {
        [MBProgressHUD showFail:@"请输入开户的银行" view:self.view];
        return;
    }
    if ([NSString isEmptyString:self.cardCityTextFd.text]) {
        [MBProgressHUD showFail:@"请输入开户的城市" view:self.view];
        return;
    }
    if ([NSString isEmptyString:self.phoneTextFd.text] ) {
        [MBProgressHUD showFail:@"请输入预留的手机号" view:self.view];
        return;
    }
    if (![NSString isMobileNum:self.phoneTextFd.text] ) {
        [MBProgressHUD showFail:@"预留的手机号不正确，请重新输入！" view:self.view];
        return;
    }
    //申请绑卡
    //  [self applyCardTie];
    [self updateBankInfo];
}

//提交信息到后台
-(void)updateBankInfo{
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:@"2" forKey:@"postion"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    
    [param setObject:[NSString deleteStrWithOrignalStr:self.cardNumTextFd.text specailStr:@" "] forKey:@"bank_account"];
    [param setObject:self.cardNameTextFd.text forKey:@"bank_name"];
    
    [param setObject:self.phoneTextFd.text forKey:@"bank_phone"];
    //渠道
//    [param setObject:@"hjr_app" forKey:@"channel_key"];
    
    NSArray* cityArr = [self.cardCityTextFd.text componentsSeparatedByString:@" "];
    if (cityArr.count >= 1) {
        [param setObject:cityArr[1] forKey:@"bank_city"];
    }else{
         [param setObject:_cardCityTextFd.text forKey:@"bank_city"];
    }
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:accountApplyURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        //下一步 -  基本信息
        if (self.isShowNext == YES && self.isModify == NO) {
            [self next:nil];
        }
        if (self.isShowNext == YES && self.isModify == YES) {
            YMApplyMainController* yvc = [[YMApplyMainController alloc]init];
            yvc.title = @"提交资料，立即申请开户";
            [self.navigationController pushViewController:yvc animated:YES];
        }
        if (weakSelf.isShowNext == NO) {
            [MBProgressHUD showSuccess:@"上传资料成功！" view:self.view];
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
- (IBAction)cameraBtnClick:(id)sender {
    DDLog(@"相机按钮点击啦");
    if (self.isCheckStatus == YES) {
        [MBProgressHUD showFail:@"银行储蓄卡审核已通过，不可修改！" view:self.view];
        return;
    }
    //选择城市列表
    SCCaptureCameraController *con = [[SCCaptureCameraController alloc] init];
    con.scNaigationDelegate = self;
    con.iCardType =  TIDBANK ;//tap.view.tag == 100 ? TIDCARD2 : TIDCARDBACK;
    // con.TimeKey = TimeKeyS; //自动识别身份证正反面
    // con.iCardType =   TIDCARD2;
    // con.isDisPlayTxt = YES;
    // con.isDisPlayView = YES;
    
    // con.ScanMode = TIDC_SCAN_MODE;
    [self presentViewController:con animated:YES completion:NULL];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.cardCityTextFd) {
        //选择城市列表
        SelectPickerView* svc = [[SelectPickerView alloc]init];
        svc.delegate = self;
        svc.type = @"city";
        svc.metaDataArr = [YMDataManager addressArray];
        self.cardCityTextFd.inputView = svc;
        DDLog(@"key == %@",self.bankListArr);
    }
    
//    if (textField == self.cardNumTextFd) {
//        return  NO;
//    }
    return YES;
}
#pragma mark - SCNavigationControllerDelegate
// 银行卡识别接口
- (void)sendBankCardInfo:(NSString *)bank_num BANK_NAME:(NSString *)bank_name BANK_ORGCODE:(NSString *)bank_orgcode BANK_CLASS:(NSString *)bank_class CARD_NAME:(NSString *)card_name{
    
    self.cardNumTextFd.text = bank_num;
    self.cardNameTextFd.text = bank_name;
    //银行名
}
- (void)sendBankCardImage:(UIImage *)BankCardImage{
    
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
-(void)setValueWithParam:(NSDictionary* )param{
    if ([param[@"type"] isEqualToString:@"bank"]) {
        self.cardNameTextFd.text = param[@"component0"];
    }
    if ([param[@"type"] isEqualToString:@"city"]) {
        self.cardCityTextFd.text = [NSString stringWithFormat:@"%@ %@ %@",param[@"component0"],param[@"component1"],param[@"component2"]];
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bankListArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YMBankListCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YMBankListCollectionViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [YMBankListCollectionViewCell shareCell];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld、%@",(long)indexPath.row + 1,self.bankListArr[indexPath.row]];
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(SCREEN_WIDTH -30) * 0.3 ,20};

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return (CGSize){SCREEN_WIDTH,44};
//}

//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return (CGSize){SCREEN_WIDTH,22};
//}

#pragma mark -


@end
