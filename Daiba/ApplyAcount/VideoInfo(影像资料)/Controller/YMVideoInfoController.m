//
//  YMVideoInfoController.m
//  Daiba
//
//  Created by YouMeng on 2017/7/31.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMVideoInfoController.h"
#import "YMCameraController.h"
#import "YMVideoRecordController.h"
#import "FMFileVideoController.h"
#import "YMMainController.h"
#import "YMTabBarController.h"
#import "YMApplyMainController.h"
#import "XCFileManager.h"
#import "YMWebViewController.h"

@interface YMVideoInfoController ()

//photo
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
//vedio
@property (weak, nonatomic) IBOutlet UIImageView *vedioImgView;

//确定按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (strong,  nonatomic) IBOutletCollection(UIImageView) NSArray *imgsArr;

//上传文件的数组
@property(nonatomic,strong)NSMutableArray* uploadArr;
//显示框
@property(nonatomic,strong)MBProgressHUD* HUD;
@property(nonatomic,strong)NSData* videoData;

//头部img
@property(nonatomic,strong)UIImage* headImg;
@end

@implementation YMVideoInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //修改view
    [self modifyView];
    
    if (self.isShowNext == YES) {
        self.navigationItem.rightBarButtonItem =  [UIBarButtonItem itemWithTitle:@"最后一步" font:Font(13) titleColor:WhiteColor target:self action:@selector(next:)];
    }
    
}
-(void)next:(UIButton* )nextBtn{
    DDLog(@"最后一步");
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVideoImageAndData:) name:@"videoSaved" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"videoSaved" object:nil];
}
-(void)getVideoImageAndData:(NSNotification* )notif{
 
    UIImage* videoThumImage =  notif.object[@"image"];
    NSData* videoData = notif.object[@"video"];
    //存储图片和视频
    [XCFileManager writeLoacalFileWithFileData:videoThumImage dataKey:kVideoPreImage filePath:videoImgFilePath];
    
     [XCFileManager writeLoacalFileWithFileData:videoData dataKey:kVideo filePath:videoFilePath];
    DDLog(@"notif data = %lu",(unsigned long)videoData.length);
    self.vedioImgView.image = videoThumImage;
    self.videoData = videoData;
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
    }

    [YMTool viewLayerWithView:_sureBtn cornerRadius:5 boredColor:ClearColor borderWidth:1];
    for (UIImageView* imgView in self.imgsArr) {
        // imgView.userInteractionEnabled = YES;
        [YMTool addTapGestureOnView:imgView target:self selector:@selector(imgViewClick:) viewController:self];
    }
    //界面赋值
    UIImage* headImage = [XCFileManager getLocalFileWithFilePath:headImgFilePath fileKey:kHeadImage];
    self.headImg = headImage;
    if (headImage) {
        _photoImgView.image = headImage;
    }
    UIImage* backImage = [XCFileManager getLocalFileWithFilePath:videoImgFilePath fileKey:kVideoPreImage];
    if (backImage) {
        _vedioImgView.image = backImage;
    }
    //本地视频
    self.videoData = [XCFileManager getDataFileWithFilePath:videoFilePath fileKey:kVideo];
}
#pragma mark - 按钮
- (IBAction)sureBtnClick:(id)sender {
    if (self.photoImgView.image == nil || self.headImg == nil) {
        [MBProgressHUD showFail:@"请拍摄实时头像！" view:self.view];
        return;
    }
    if (self.videoData == nil) {
        [MBProgressHUD showFail:@"请先录制视频！" view:self.view];
        return;
    }
    DDLog(@"点击啦确定按钮");
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:@"5" forKey:@"postion"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    //渠道
//    [param setObject:@"hjr_app" forKey:@"channel_key"];
    YMWeakSelf;
    //加载中
    [self.HUD showAnimated:YES whileExecutingBlock:^{
        [[HttpManger sharedInstance]postFileHTTPReqAPI:uploadVideoURL params:param filesArr:@[self.photoImgView.image,self.videoData].mutableCopy filesKey:@[@"photo",@"video"].mutableCopy view:self.view loading:NO completionHandler:^(id task, id responseObject, NSError *error) {
            DDLog(@"上传成功啦");
            if (self.isShowNext == YES) {
                [MBProgressHUD showSuccess:@"上传成功！" view:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    DDLog(@"手机认证");
                    YMWebViewController* wvc = [[YMWebViewController alloc]init];
                    wvc.urlStr = getMobileURL;
                    wvc.hidesBottomBarWhenPushed = YES;
                    wvc.isSecret = YES;
                    wvc.title = @"手机认证";
                    wvc.isNext = YES;
//                    wvc.agreeBlock = ^(NSString *isAgree) {
//                        if (isAgree.integerValue == 1) {
//            
//                            [kUserDefaults setBool:YES  forKey:kIsPhoneIdentify];
//                            [kUserDefaults synchronize];
//                            
//                            // 跳转到首页 = 回跳
//                            YMApplyMainController* yvc = [[YMApplyMainController alloc]init];
//                            yvc.title = @"提交资料，立即申请开户";
//                            yvc.isNext = YES;
//                            [self.navigationController pushViewController:yvc animated:YES];
//
//                        }
//                    };
                    [self.navigationController pushViewController:wvc animated:YES];
                });
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

-(void)imgViewClick:(UITapGestureRecognizer* )tap{
    DDLog(@"tap tag == %ld",tap.view.tag);
    YMWeakSelf;
    if (tap.view.tag == 100) {

        YMCameraController * ymc = [[YMCameraController alloc]init];
        ymc.imgBlock = ^(UIImage * image){
            weakSelf.headImg = image;
            _photoImgView.image = image;
            //存储正面身份证
            [XCFileManager writeLoacalFileWithFileData:image dataKey:kHeadImage filePath:headImgFilePath];
        };
        [self presentViewController:ymc animated:YES completion:nil];
        
    }else{
        FMFileVideoController *fileVC = [[FMFileVideoController alloc] init];
        YMNavigationController *NAV = [[YMNavigationController alloc] initWithRootViewController:fileVC];
        [self presentViewController:NAV animated:YES completion:nil];

    }
}

- (MBProgressHUD *)HUD{
    if (!_HUD) {
        MBProgressHUD *hud= [[MBProgressHUD alloc] initWithView:KeyWindow];
#warning 打断点会停
        [KeyWindow addSubview:hud];
        hud.label.text = @"努力上传中";
        hud.label.font = [UIFont systemFontOfSize:12];
        hud.mode = MBProgressHUDModeIndeterminate;

        _HUD = hud;
    }
    return _HUD;
}
-(NSMutableArray *)uploadArr{
    if (!_uploadArr) {
        _uploadArr = [[NSMutableArray alloc]init];
    }
    return _uploadArr;
}

@end
