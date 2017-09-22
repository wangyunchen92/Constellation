//
//  FMVideoPlayController.m
//  fmvideo
//
//  Created by qianjn on 2016/12/30.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "FMVideoPlayController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "XCFileManager.h"

@interface FMVideoPlayController ()
@property (nonatomic, strong) MPMoviePlayerController *videoPlayer;
@property (nonatomic, strong) NSString *from;

// 获取缩略图
@property (nonatomic, strong) UIImage *videoCover;
@property (nonatomic, assign) NSTimeInterval enterTime;
@property (nonatomic, assign) BOOL hasRecordEvent;

@end

@implementation FMVideoPlayController

- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
   // self.view.backgroundColor = RGBA(0, 0, 0, 0.5);
   // self.view.frame = CGRectMake(0, SCREEN_HEGIHT - SCREEN_WIDTH * 1.25, SCREEN_WIDTH, 1.25 * SCREEN_WIDTH);
    
    self.videoPlayer = [[MPMoviePlayerController alloc] init];
    [self.videoPlayer.view setFrame: self.view.bounds];//
    self.videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.videoPlayer.view];
    [self.videoPlayer prepareToPlay];
    self.videoPlayer.controlStyle = MPMovieControlStyleNone;
    self.videoPlayer.shouldAutoplay = YES;
    self.videoPlayer.repeatMode = MPMovieRepeatModeOne;
    self.title = NSLocalizedString(@"PreView", nil);
    
    
    self.videoPlayer.contentURL = self.videoUrl;
    [self.videoPlayer play];
    
    [self buildNavUI];
    _enterTime = [[NSDate date] timeIntervalSince1970];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChanged) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayer];
     [self captureImageAtTime:0.01];
    //截屏
   // [self.videoPlayer requestThumbnailImagesAtTimes:@[@(0), @(1)] timeOption:MPMovieTimeOptionNearestKeyFrame];
   
//    MPMoviePlayerPlaybackStateDidChangeNotification  添加播放状态的监听
    
//    MPMoviePlayerPlaybackDidFinishNotification 播放完成
//    MPMoviePlayerDidEnterFullscreenNotification 全屏
//    MPMoviePlayerDidExitFullscreenNotification
    
//  MPMoviePlayerThumbnailImageRequestDidFinishNotification 截屏完成通知
    
}

- (void)buildNavUI
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"video_play_nav_bg"];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    imageView.userInteractionEnabled = YES;
    
    //取消按钮 --- 点击取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"cancelColor"] forState:UIControlStateNormal];
    [cancelBtn setTintColor:DefaultNavBarColor];
    cancelBtn.frame = CGRectMake(5, 10, 44, 44);
    [imageView addSubview:cancelBtn];
    
    //完成按钮  --  点击完成
    UIButton *Done = [UIButton buttonWithType:UIButtonTypeCustom];
    [Done addTarget:self action:@selector(DoneAction) forControlEvents:UIControlEventTouchUpInside];
    [Done setTitle:@"完成" forState:UIControlStateNormal];
    Done.frame = CGRectMake(SCREEN_WIDTH - 55, 10, 50, 44);
    [Done setTitleColor:DefaultNavBarColor forState:UIControlStateNormal];
    [imageView addSubview:Done];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:imageView];
    
    
    UILabel* tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, SCREEN_HEGIHT - 30, SCREEN_WIDTH - 20 * 2, 30)];
    tipsLabel.text = @"正在回放朗读内容，请检查确认。";
    tipsLabel.textColor = WhiteColor;
    tipsLabel.font = Font(13);
    [self.view addSubview:tipsLabel];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)commit
{
    
}
#pragma mark - notification
#pragma state
- (void)stateChanged
{
    switch (self.videoPlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            [self trackPreloadingTime];
            break;
        case MPMoviePlaybackStatePaused:
            break;
        case MPMoviePlaybackStateStopped:
            break;
        default:
            break;
    }
}
#pragma mark - 完成播放
-(void)videoFinished:(NSNotification*)aNotification{
    int value = [[aNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (value == MPMovieFinishReasonPlaybackEnded) {
        // 视频播放结束
        DDLog(@"视频播放结束");
    }
}

- (void)trackPreloadingTime
{
    
}

- (void)dismissAction
{
    [self.videoPlayer stop];
    //self.videoPlayer = nil;
    [self.navigationController popViewControllerAnimated:NO];
    
}
- (void)DoneAction
{
    [self.videoPlayer stop];
//    self.videoPlayer = nil;
    [self convertVideoWithURL:self.videoUrl];
     // [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.videoPlayer stop];
    self.videoPlayer = nil;
}

//截图获取封面
- (void)captureImageAtTime:(float)time
{
    [self.videoPlayer requestThumbnailImagesAtTimes:@[@(time)] timeOption:MPMovieTimeOptionNearestKeyFrame];
}

- (void)captureFinished:(NSNotification *)notification
{
    
                                          //MPMovieTimeOptionNearestKeyFrame  MPMoviePlayerThumbnailImageKey
    self.videoCover = notification.userInfo[MPMoviePlayerThumbnailImageKey];
    if (self.videoCover == nil) {
        self.videoCover = [self coverIamgeAtTime:1];
    }
    DDLog(@"video cover == %@",self.videoCover);
    
    NSLog(@"captureFinished notification = %@", notification);
//    if (self.delegate && [self.delegate respondsToSelector:@selector(moviePlayerDidCapturedWithImage:)]) {
//        [self.delegate moviePlayerDidCapturedWithImage:notification.userInfo[MPMoviePlayerThumbnailImageKey]];
//    }

}

//获取缩略图
- (UIImage*)coverIamgeAtTime:(NSTimeInterval)time {
    [self.videoPlayer requestThumbnailImagesAtTimes:@[@(time)] timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : [UIImage new];
    
    return thumbnailImage;
}
//videoURL:本地视频路径    time：用来控制视频播放的时间点图片截取
-(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage; 
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//存放视频的文件夹
- (NSString *)videoFolder
{
    NSString *cacheDir = [XCFileManager cachesDir];
    NSString *direc = [cacheDir stringByAppendingPathComponent:VIDEO_FOLDER];
    if (![XCFileManager isExistsAtPath:direc]) {
        [XCFileManager createDirectoryAtPath:direc];
    }
    return direc;
}
//清空文件夹
- (void)clearFile
{
    [XCFileManager removeItemAtPath:[self videoFolder]];
    
}
//写入的视频路径
- (NSString *)createVideoFilePath
{
    NSString *videoName = [NSString stringWithFormat:@"%@.mp4", [NSUUID UUID].UUIDString];
    NSString *path = [[self videoFolder] stringByAppendingPathComponent:videoName];
    return path;
}

//#pragma mark - 导出视频
- (void)convertVideoWithURL:(NSURL *)fileUrl{
    
    __block NSURL *outputFileURL = fileUrl;
    NSString *videoFilepath = [self createVideoFilePath];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:outputFileURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    __weak __typeof(self)weakSelf = self;
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
    {
        //低质量
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputURL = [[NSURL alloc] initFileURLWithPath:videoFilepath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    NSError *exportError = exportSession.error;
                    NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                }
                    break;
                case AVAssetExportSessionStatusCancelled:
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    //获取视频的thumbnail
//                    MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:exportSession.outputURL] ;
                //    UIImage  *thumbnail = [player thumbnailImageAtTime:0.01 timeOption:MPMovieTimeOptionNearestKeyFrame];
//                    player = nil;
                    NSData * imageData = UIImageJPEGRepresentation(self.videoCover,1);
            
                    DDLog(@"视频转码成功");
                    NSData *videoData = [NSData dataWithContentsOfFile:videoFilepath];
                    DDLog(@"视频文件大小 == %f M  图片文件大小 == %ld",(unsigned long)videoData.length * 0.001 * 0.001,[imageData length]/1024);
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"videoSaved" object:@{@"image":self.videoCover,@"video":
                                                      videoData                                                   }];
                    
                    //退出
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                    });
                    
                  //   [weakSelf completeWithUrl:exportSession.outputURL];
                }
                    
                   
                    break;
                default:
                    break;
            }
        }];
    }
}
// 写入相册
- (void)completeWithUrl:(NSURL *)url{
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib writeVideoAtPathToSavedPhotosAlbum:url completionBlock:nil];
}
//获取缩略图
- (void)requestThumbnailImagesAtTimes:(NSArray *)playbackTimes timeOption:(MPMovieTimeOption)option{
    DDLog(@"playbackTimes == %@",playbackTimes);
}

@end
