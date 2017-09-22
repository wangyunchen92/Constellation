//
//  FMFVideoView.m
//  FMRecordVideo
//
//  Created by qianjn on 2017/3/12.
//  Copyright © 2017年 SF. All rights reserved.
//
//  Github:https://github.com/suifengqjn
//  blog:http://gcblog.github.io/
//  简书:http://www.jianshu.com/u/527ecf8c8753
#import "FMFVideoView.h"

#import "ExtendButton.h"

#define progressViewWidth      40
#define progrsRecordBtnMargin  5
@interface FMFVideoView ()<FMFModelDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *timelabel;
@property (nonatomic, strong) UIButton *turnCamera;
@property (nonatomic, strong) UIButton *flashBtn;


@property (nonatomic, assign) CGFloat recordTime;

@property (nonatomic, strong, readwrite) FMFModel *fmodel;

@end

@implementation FMFVideoView

-(instancetype)initWithFMVideoViewType:(FMVideoViewType)type
{

    self = [super initWithFrame:CGRectMake(0, SCREEN_HEGIHT - SCREEN_WIDTH * 1.25, SCREEN_WIDTH , SCREEN_WIDTH * 1.25)];//[UIScreen mainScreen].bounds
    if (self) {
        [self BuildUIWithType:type];
    }
    
    return self;
}

#pragma mark - view
- (void)BuildUIWithType:(FMVideoViewType)type
{
    self.fmodel = [[FMFModel alloc] initWithFMVideoViewType:type superView:self];
    self.fmodel.delegate = self;
    
    self.topView = [[UIView alloc] init];
    self.topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [self addSubview:self.topView];
    
    self.timeView = [[UIView alloc] init];
    self.timeView.hidden = YES;
    self.timeView.frame = CGRectMake((SCREEN_WIDTH - 100)/2, 16, 100, 34);
    self.timeView.backgroundColor = HEX(@"242424");
//    [UIColor colorWithRGB:0x242424 alpha:0.7];
    self.timeView.layer.cornerRadius = 4;
    self.timeView.layer.masksToBounds = YES;
    [self addSubview:self.timeView];
    
    
    UIView *redPoint = [[UIView alloc] init];
    redPoint.frame = CGRectMake(0, 0, 6, 6);
    redPoint.layer.cornerRadius = 3;
    redPoint.layer.masksToBounds = YES;
    redPoint.center = CGPointMake(25, 17);
    redPoint.backgroundColor = [UIColor redColor];
    [self.timeView addSubview:redPoint];
    
    self.timelabel =[[UILabel alloc] init];
    self.timelabel.font = [UIFont systemFontOfSize:13];
    self.timelabel.textColor = [UIColor whiteColor];
    self.timelabel.frame = CGRectMake(40, 8, 40, 28);
    [self.timeView addSubview:self.timelabel];
    
    //扩大 响应范围 -- 关闭
    self.cancelBtn = [ExtendButton buttonWithType:UIButtonTypeCustom];
    self.cancelBtn.frame = CGRectMake(15, 14, 16, 16);
    [self.cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.cancelBtn];
    
    // 切换摄像头
    self.turnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    self.turnCamera.frame = CGRectMake(SCREEN_WIDTH - 60 - 28, 11, 28, 22);
    [self.turnCamera setImage:[UIImage imageNamed:@"listing_camera_lens"] forState:UIControlStateNormal];
    [self.turnCamera addTarget:self action:@selector(turnCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.turnCamera sizeToFit];
    [self.topView addSubview:self.turnCamera];
    
    //闪光灯
    self.flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashBtn.frame = CGRectMake(SCREEN_WIDTH - 22 - 15, 11, 22, 22);
    [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_off"] forState:UIControlStateNormal];
    [self.flashBtn addTarget:self action:@selector(flashAction) forControlEvents:UIControlEventTouchUpInside];
    [self.flashBtn sizeToFit];
    [self.topView addSubview:self.flashBtn];
    
   // 进度 1.25 * SCREEN_WIDTH == Height
   // CGFloat proViewWidth = 40;
    CGFloat bottomMargin = 20;
    self.progressView = [[FMRecordProgressView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - progressViewWidth) * 0.5, 1.25 * SCREEN_WIDTH - bottomMargin - progressViewWidth, progressViewWidth, progressViewWidth)];
    //CGRectMake((SCREEN_WIDTH - 62)/2, SCREEN_HEGIHT - 32 - 62, 62, 62)
    self.progressView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.progressView];
    
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordBtn addTarget:self.delegate action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.recordBtn.frame = CGRectMake(progrsRecordBtnMargin, progrsRecordBtnMargin, progressViewWidth - 10, progressViewWidth - 10);
    self.recordBtn.backgroundColor = [UIColor redColor];
    self.recordBtn.layer.cornerRadius = (progressViewWidth - progrsRecordBtnMargin * 2) * 0.5 ;
    self.recordBtn.layer.masksToBounds = YES;
    [self.progressView addSubview:self.recordBtn];
    [self.progressView resetProgress];
//    //进度
//    self.progressView = [[FMRecordProgressView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 62), 1.25 * SCREEN_WIDTH - SCREEN_HEGIHT + 10, 62, 62)];
//    //CGRectMake((SCREEN_WIDTH - 62)/2, SCREEN_HEGIHT - 32 - 62, 62, 62)
//    self.progressView.backgroundColor = [UIColor clearColor];
//    [self addSubview:self.progressView];
//    
//    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.recordBtn addTarget:self.delegate action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
//    self.recordBtn.frame = CGRectMake(5, 5, 52, 52);
//    self.recordBtn.backgroundColor = [UIColor redColor];
//    self.recordBtn.layer.cornerRadius = 26;
//    self.recordBtn.layer.masksToBounds = YES;
//    [self.progressView addSubview:self.recordBtn];
//    [self.progressView resetProgress];
}

- (void)updateViewWithRecording
{
    self.timeView.hidden = NO;
    self.topView.hidden = YES;
    [self changeToRecordStyle];
}

- (void)updateViewWithStop
{
    self.timeView.hidden = YES;
    self.topView.hidden = NO;
    [self changeToStopStyle];
}

- (void)changeToRecordStyle
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordBtn.center;
        CGRect rect = self.recordBtn.frame;
        rect.size = CGSizeMake(28, 28);
        self.recordBtn.frame = rect;
        self.recordBtn.layer.cornerRadius = 4;
        self.recordBtn.center = center;
    }];
}
//调整曝光模式
- (void)changeToStopStyle
{
    
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordBtn.center;
        CGRect rect = self.recordBtn.frame;
       // rect.size = CGSizeMake(52, 52);
        self.recordBtn.frame = rect;
       // self.recordBtn.layer.cornerRadius = 26;
        self.recordBtn.center = center;
    }];
    
}
#pragma mark - action


- (void)turnCameraAction
{
     [self.fmodel turnCameraAction];
}

- (void)flashAction
{
    [self.fmodel switchflash];
}

- (void)startRecord
{
    DDLog(@"开始录制");
    if (self.fmodel.recordState == FMRecordStateInit) {
        [self.fmodel startRecord];
    } else if (self.fmodel.recordState == FMRecordStateRecording) {
        [self.fmodel stopRecord];
    } else if (self.fmodel.recordState == FMRecordStatePause) {
        
    }
}

- (void)reset
{
    [self.fmodel reset];
}

#pragma mark - FMFModelDelegate

- (void)updateFlashState:(FMFlashState)state
{
    if (state == FMFlashOpen) {
        [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_on"] forState:UIControlStateNormal];
    }
    if (state == FMFlashClose) {
        [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_off"] forState:UIControlStateNormal];
    }
    if (state == FMFlashAuto) {
        [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_auto"] forState:UIControlStateNormal];
    }
}

- (void)updateRecordState:(FMRecordState)recordState
{
    if (recordState == FMRecordStateInit) {
        [self updateViewWithStop];
        [self.progressView resetProgress];
        //开始录制
    } else if (recordState == FMRecordStateRecording) {
        [self updateViewWithRecording];
        if (self.delegate && [self.delegate respondsToSelector:@selector(startRecordDelegateAction)]) {
            [self.delegate startRecordDelegateAction];
        }
    } else if (recordState == FMRecordStatePause) {
         [self updateViewWithStop];
    } else  if (recordState == FMRecordStateFinish) {
        [self updateViewWithStop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordFinishWithvideoUrl:)]) {
            [self.delegate recordFinishWithvideoUrl:self.fmodel.videoUrl];
        }
    }
}

- (void)dismissVC
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissVC)]) {
        [self.delegate dismissVC];
    }
}

- (void)updateRecordingProgress:(CGFloat)progress
{
    [self.progressView updateProgressWithValue:progress];
    self.timelabel.text = [self changeToVideotime:progress * RECORD_MAX_TIME];
    [self.timelabel sizeToFit];
}

- (NSString *)changeToVideotime:(CGFloat)videocurrent {
    
    return [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
    
}
@end
