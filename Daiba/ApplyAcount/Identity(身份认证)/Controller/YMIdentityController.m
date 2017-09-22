//
//  YMIdentityController.m
//  Daiba
//
//  Created by YouMeng on 2017/7/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMIdentityController.h"
#import "YMWarnView.h"

#import "YMBankCardController.h"
#import "YMApplyMainController.h"
#import "XCFileManager.h"

#import "IOSOCRAPI.h"
#import "Globaltypedef.h"
#import "SCCaptureCameraController.h"

#import "CustomDetectViewController.h"
#import <MGBaseKit/MGBaseKit.h>
#import <MGLivenessDetection/MGLivenessDetection.h>



@interface YMIdentityController ()<SCNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *warnView;
//身份证采集view
@property (weak, nonatomic) IBOutlet UIView *idTakeView;
//采集信息View
@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UILabel *sureInfoLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
//身份证采集view 高度 需计算 自定义
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idTakeViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeight;

//属性
@property (weak, nonatomic) IBOutlet UIImageView *fontImgView;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFd;
@property (weak, nonatomic) IBOutlet UITextField *idNumTextFd;

//icon 数组
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *iconsArr;
//有效期
@property (weak, nonatomic) IBOutlet UITextField *vaildTextFd;

@property(nonatomic,strong)IDInfo* infoModel;

@property(nonatomic,strong)MBProgressHUD *HUD;

//是否有前后的图片
@property(nonatomic,assign)BOOL isHasFont;
@property(nonatomic,assign)BOOL isHasBack;

@end

@implementation YMIdentityController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.isShowNext == YES) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"第1/6步" font:Font(13) titleColor:WhiteColor target:self action:nil];
    }
    //给界面赋值
    [self setViewWithData];
    
    //设置view
    [self modifyView];
}

-(void)next:(UIButton* )nextBtn{
    //人脸识别
    if (![MGLiveManager getLicense]) {
        [MGLiveManager licenseForNetWokrFinish:^(bool License) {
            NSLog(@"%@", [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"title_license", nil), License ? NSLocalizedString(@"title_success", nil) : NSLocalizedString(@"title_failure", nil)]);
        }];
        return;
    }
    CustomDetectViewController* customDetectVC = [[CustomDetectViewController alloc] initWithDefauleSetting];
    customDetectVC.hidesBottomBarWhenPushed = YES;
    customDetectVC.isShowNext = YES;
    [self.navigationController pushViewController:customDetectVC animated:YES];
    
    
    // YMBankCardController* yvc = [[YMBankCardController alloc]init];
    // yvc.title = @"绑定银行储蓄卡";
    // yvc.isShowNext = YES;
    // [self.navigationController pushViewController:yvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//如果用户先点击的是坡面
-(IDInfo *)infoModel{
    if (!_infoModel) {
        _infoModel = [[IDInfo alloc]init];
    }
    return _infoModel;
}

//初始化修改👭
-(void)modifyView {
    
    [YMTool viewLayerWithView:_sureBtn cornerRadius:5 boredColor:DefaultNavBarColor borderWidth:1];

    YMWarnView* warnView = [YMWarnView shareViewWithIconStr:@"感叹" warnStr:@"必须使用本人身份证，身份证将联网公安部进行认证" tapBlock:^(UILabel *label) {
        DDLog(@"点击啦 warn");
    }];
    [self.warnView addSubview:warnView];

    //图片高度 + label高度 + 底部间距
    self.idTakeViewHeight.constant = (10 + 16 + 5) + (SCREEN_WIDTH - 15 * 2 - 10) * 0.5 * 218 / 338  + 20 ;
    
    for (UIImageView* imgView in self.iconsArr) {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIdImgClick:)];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:tap];
    }
    if (self.isHaveImage == NO || [NSString isEmptyString:self.idInfoModel.num]) {
        self.infoView.hidden = YES;
        self.infoViewHeight.constant = 0;
    }else{
        self.infoView.hidden = NO;
        self.infoViewHeight.constant = 150;
    }
   
}

-(void)setViewWithData{
    
    if (![NSString isEmptyString:self.idInfoModel.num]) {
        if (self.idInfoModel.checkStatus == 1) {
            _nameTextFd.userInteractionEnabled = NO;
            _idNumTextFd.userInteractionEnabled = NO;
        }else{
            _nameTextFd.userInteractionEnabled = YES;
            _idNumTextFd.userInteractionEnabled = YES;
        }
        _nameTextFd.text  = self.idInfoModel.name;
        _idNumTextFd.text = self.idInfoModel.num;
        _vaildTextFd.text = self.idInfoModel.card_period;
    }
    UIImage* frontImage = [XCFileManager getLocalFileWithFilePath:FrontIdImgFilePath fileKey:kFrontIdImg];
    if (frontImage) {
        _fontImgView.image = frontImage;
        self.isHasFont = YES;
    }
    UIImage* backImage = [XCFileManager getLocalFileWithFilePath:BackIdImgFilePath fileKey:kBackIdImg];
    if (backImage) {
         _backImgView.image = backImage;
         self.isHasBack = YES;
    }
}

-(void)tapIdImgClick:(UITapGestureRecognizer* )tap{
    DDLog(@"tap == %ld",tap.view.tag);
    SCCaptureCameraController *con = [[SCCaptureCameraController alloc] init];
    con.scNaigationDelegate = self;
    con.iCardType =  TIDCARD2 ;
    [self presentViewController:con animated:YES completion:NULL];

}
#pragma mark - SCNavigationControllerDelegate
// 获取身份证正面信息
- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *) address NUM:(NSString *)num
{
    //审核未通过，可修改身份证信息
    if (self.idInfoModel.checkStatus != 1) {
        _nameTextFd.text = name;
        _idNumTextFd.text = num;
       
        //读取到信息
        self.infoView.hidden = NO;
        self.infoViewHeight.constant = 150;
    }
    
    NSLog(@"idc  = %@\n%@\n%@\n%@\n%@\n%@\n",name,sex,folk,birthday,address,num);
}
// 获取身份证反面信息
- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period
{
    //审核未通过，可修改身份证信息
    if (self.idInfoModel.checkStatus != 1) {
        _vaildTextFd.text = period;
    }
    //有效期
    if ([NSString isEmptyString:_vaildTextFd.text]) {
        _vaildTextFd.text = period;
    }
    NSLog(@"idcback  = %@\n%@\n",issue,period);
}
- (void)sendFieldImage:(TFIELDID) field  image:(UIImage *)fieldimage{
    if (fieldimage != NULL) {
        _backImgView.image = fieldimage;
    }
}
//获取拍照的图片
- (void)sendTakeImage:(TCARD_TYPE) iCardType image:(UIImage *)cardImage
{
    if (iCardType == TIDCARD2) {
         _fontImgView.image = cardImage;
         self.isHasFont = YES;
        //存储正面身份证
        [XCFileManager writeLoacalFileWithFileData:cardImage dataKey:kFrontIdImg filePath:FrontIdImgFilePath];
        
    }else if (iCardType == TIDCARDBACK){
         _backImgView.image = cardImage;
        self.isHasBack = YES;
        //存储反面身份证
        [XCFileManager writeLoacalFileWithFileData:cardImage dataKey:kBackIdImg filePath:BackIdImgFilePath];
    }
}
- (IBAction)sureBtnClick:(id)sender {
    if (self.isHasFont == NO) {
        [MBProgressHUD showFail:@"请上传正面身份证图片！" view:self.view];
        return;
    }
    if (self.isHasBack == NO) {
        [MBProgressHUD showFail:@"请上传反面身份证图片！" view:self.view];
        return;
    }
    if ([NSString isEmptyString:_idNumTextFd.text]) {
        [MBProgressHUD showFail:@"身份证号码为空，请重新扫描身份证！" view:self.view];
        return;
    }
    if ([NSString isEmptyString:_idNumTextFd.text]) {
        [MBProgressHUD showFail:@"用户姓名为空，请重新扫描身份证！" view:self.view];
        return;
    }
    if ([NSString isEmptyString:_vaildTextFd.text]) {
        [MBProgressHUD showFail:@"身份证有效期为空，请重新扫描身份证反面！" view:self.view];
        return;
    }
    NSMutableArray* imgsArr = [[NSMutableArray alloc]init];
    for (UIImageView* imgView in self.iconsArr) {
        if (imgView.image) {
            [imgsArr addObject:imgView.image];
        }
    }
    DDLog(@"确认并提交  imgArr == %@",imgsArr);
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
     [param setObject:@"ios" forKey:@"source"];
     [param setObject:@"1" forKey:@"postion"];
     [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
     [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
     [param setObject:self.nameTextFd.text forKey:@"real_name"]; //
     [param setObject:self.idNumTextFd.text forKey:@"card_number"];//
     [param setObject:_vaildTextFd.text forKey:@"card_period"];
    YMWeakSelf;
    //加载中
    [self.HUD showAnimated:YES whileExecutingBlock:^{
        [[HttpManger sharedInstance]postFileHTTPReqAPI:accountApplyURL params:param imgsArr:imgsArr view:self.view loading:NO completionHandler:^(id task, id responseObject, NSError *error) {
       
            //存储用户的身份证号
            [kUserDefaults setObject:_nameTextFd.text forKey:kRealName];
            [kUserDefaults setObject:_idNumTextFd.text forKey:kIDNum];
            [kUserDefaults synchronize];
            
            //下一步 - 绑定银行卡
            if (weakSelf.isShowNext == YES) {
                if ( weakSelf.isModify == NO) {
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
    }];
}

- (MBProgressHUD *)HUD{
    if (!_HUD) {
        MBProgressHUD *hud= [[MBProgressHUD alloc] initWithView:KeyWindow];
#warning 打断点会停
        [KeyWindow addSubview:hud];
        hud.label.text = @"努力上传中";
        hud.label.font = [UIFont systemFontOfSize:12];
        hud.mode = MBProgressHUDModeIndeterminate;
        //hud.progress = 0;
        _HUD = hud;
    }
    return _HUD;
}

@end
