//
//  CustomDetectViewController.m
//  MegLiveDemo
//
//  Created by megviio on 2017/5/26.
//  Copyright © megvii. All rights reserved.
//

#import "CustomDetectViewController.h"
#import "DetectFinishViewController.h"
#import "MyBottomView.h"
#import "FaceIDNetAPI.h"
#import "XCFileManager.h"
#import "NSString+Catogory.h"
#import "YMIdentityController.h"
#import "YMBankCardController.h"
#import "YMApplyMainController.h"


@interface CustomDetectViewController ()

@end

@implementation CustomDetectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@", NSLocalizedString(@"key_custom_UI", nil)];
    //返回到信息主页
    if (self.isShowNext == YES) {
         self.navigationItem.rightBarButtonItem =  [UIBarButtonItem itemWithTitle:@"第2/6步" font:Font(13) titleColor:WhiteColor target:self action:@selector(next:)];
    }
}
-(void)next:(UIButton* )btn{
    YMBankCardController* yvc = [[YMBankCardController alloc]init];
    yvc.title = @"绑定银行储蓄卡";
    yvc.isShowNext = YES;
    [self.navigationController pushViewController:yvc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    //self.navigationController.navigationBar.hidden = YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Default Setting
- (void)defaultSetting {
    if (!self.liveManager && !self.videoManager) {
        MGLiveActionManager *ActionManager = [MGLiveActionManager LiveActionRandom:NO
                                                                       actionArray:@[@1, @2, @3]
                                                                       actionCount:3];
        MGLiveErrorManager *errorManager = [[MGLiveErrorManager alloc] initWithFaceCenter:CGPointMake(0.5, 0.4)];
        
        MGVideoManager *videoManager = [MGVideoManager videoPreset:AVCaptureSessionPreset640x480
                                                    devicePosition:AVCaptureDevicePositionFront
                                                       videoRecord:NO
                                                        videoSound:NO];
        [videoManager setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
        MGLiveDetectionManager *liveManager = [[MGLiveDetectionManager alloc]initWithActionTime:8
                                                                                  actionManager:ActionManager
                                                                                   errorManager:errorManager];
        
        [self setLiveManager:liveManager];
        [self setVideoManager:videoManager];
    }
}

#pragma mark - CreateV
-(void)creatView {
    self.topViewHeight = 0;
    
    self.headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.headerView setImage:[MGLiveBundle LiveImageWithName:@"header_bg_img"]];
    [self.headerView setContentMode:UIViewContentModeScaleAspectFill];
    [self.headerView setFrame:CGRectMake(0, 0, MG_WIN_WIDTH, MG_WIN_WIDTH)];//self.topViewHeight
    
    self.bottomView = [[MyBottomView alloc] initWithFrame:CGRectMake(0,MG_WIN_WIDTH + 0,MG_WIN_WIDTH,MG_WIN_HEIGHT - MG_WIN_WIDTH - 0 - 64) andCountDownType:MGCountDownTypeRing];//self.topViewHeight  self.topViewHeight
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bottomView];
    
    DDLog(@"topViewHeight == %f",self.topViewHeight);
}

#pragma mark - Detect Result
- (void)liveDetectionFinish:(MGLivenessDetectionFailedType)type checkOK:(BOOL)check liveDetectionType:(MGLiveDetectionType)detectionType {
    
    [super liveDetectionFinish:type checkOK:check liveDetectionType:detectionType];
    //停止视频检测
    [self stopVideoWriter];
    
//    DetectFinishViewController* detectFinishVC = [[DetectFinishViewController alloc] init];
//    detectFinishVC.isDetectFinish = check;
//    if (check == YES) {
//        FaceIDData* faceData = [self.liveManager getFaceIDData];
//        [detectFinishVC setResultData:faceData];
//    }
//    [self.navigationController pushViewController:detectFinishVC animated:YES];
    if (check == YES) {
       //获取身份证正面照
        UIImage* frontImage = [XCFileManager getLocalFileWithFilePath:FrontIdImgFilePath fileKey:kFrontIdImg];
        
        //获取到的正面照
        FaceIDData* faceData = [self.liveManager getFaceIDData];
        
        [[FaceIDNetAPI sharedInstance]verifyV2FaceImages:[faceData images] userCardName:[kUserDefaults valueForKey:kRealName] userCardID:[kUserDefaults valueForKey:kIDNum] userCardImage:frontImage delta:faceData.delta finish:^(id task, id responseObject, NSError *error) {
            if (error == nil) {
                 [self updateFaceResult:responseObject];
            }else{
                DDLog(@" error  == resObject == %@",responseObject);
                NSString* error_message = responseObject[@"error_message"];
                if ([error_message isEqualToString:@"NO_SUCH_ID_NUMBER"]||
                    [error_message isEqualToString:@"ID_NUMBER_NAME_NOT_MATCH"]||
                    [error_message isEqualToString:@"INVALID_NAME_FORMAT"]||
                    [error_message isEqualToString:@"INVALID_IDCARD_NUMBER"]||
                    [error_message isEqualToString:@"NO_FACE_FOUND"]
                   ) {
                    [YMTool presentAlertViewWithTitle:@"提示" message:@"您提交的身份信息与识别到的人脸不符，请重新填写相关信息后再次识别。" cancelTitle:@"取消" cancelHandle:^(UIAlertAction *action) {
                        
                    } sureTitle:@"确定" sureHandle:^(UIAlertAction * _Nullable action) {
                        YMIdentityController* ivc = [[YMIdentityController alloc]init];
                        ivc.title = @"个人身份证";
                        ivc.isModify = YES;
                        ivc.isShowNext = YES;
                        [self.navigationController pushViewController:ivc animated:YES];

                    } controller:self];
                
                }else{
                    [YMTool presentAlertViewWithTitle:@"提示" message:@"本次识别失败，请重新尝试识别。" cancelTitle:@"取消" cancelHandle:^(UIAlertAction *action) {
                        
                    } sureTitle:@"确定" sureHandle:^(UIAlertAction * _Nullable action) {
                        //重新开启检测流程
                        [self liveFaceDetection];
                    } controller:self];
                }
            }
        }];
    }else{
        DDLog(@"检测识别失败");
        [YMTool presentAlertViewWithTitle:@"提示" message:@"本次识别失败，请重新尝试识别。" cancelTitle:@"取消" cancelHandle:^(UIAlertAction *action) {
            
        } sureTitle:@"确定" sureHandle:^(UIAlertAction * _Nullable action) {
            //重新开启检测流程
            [self liveFaceDetection];
        } controller:self];
    }
}
/**
 *  质量检测阶段，抛出错误。
 *  在质量检测时，出现错误，会调用该方法，子类重写即可。
 *  @param error 错误信息
 */
- (void)qualitayErrorMessage:(NSString *)error{
    DDLog(@"errror == %@",error);
}
//上传人脸识别的结果
-(void)updateFaceResult:(NSDictionary* )faceResult{
    YMWeakSelf;
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:[NSString dictionaryToJson:faceResult] forKey:@"face_result"];
     [param setObject:@"face" forKey:@"postion"];
     [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
     [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    [[HttpManger sharedInstance]callHTTPReqAPI:applyAccountURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
        DDLog(@"res == %@",responseObject);
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
