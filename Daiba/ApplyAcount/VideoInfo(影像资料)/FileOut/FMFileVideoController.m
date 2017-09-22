//
//  FMFileVideoController.m
//  FMRecordVideo
//
//  Created by qianjn on 2017/3/12.
//  Copyright © 2017年 SF. All rights reserved.
//
//  Github:https://github.com/suifengqjn
//  blog:http://gcblog.github.io/
//  简书:http://www.jianshu.com/u/527ecf8c8753


#import "FMFileVideoController.h"
#import "FMFVideoView.h"
#import "FMVideoPlayController.h"
#import "HyperlinksButton.h"
#import "YMHeightTools.h"

#import "YMCollectionViewCell.h"
#import "YMTopReadView.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "NSTimer+addition.h"
#import "XCFileManager.h"
#import "YMTimeController.h"

#define TopViewHeight           50
#define CollectionTextHeiht     RowHeight * 3
#define RowHeight              (SCREEN_WIDTH - 20)/11


//static void completionCallback(SystemSoundID mySSID)
//{
//    // Play again after sound play completion
//    AudioServicesPlaySystemSound(mySSID);
//}
//// 音频文件的ID
//SystemSoundID ditaVoice;


@interface FMFileVideoController ()<FMFVideoViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,AVAudioPlayerDelegate>

@property (nonatomic, strong) FMFVideoView *videoView;

@property(nonatomic,strong)UICollectionView* collectionView;

@property(nonatomic,strong)NSMutableArray* tipsArr;

// 头部View
@property(nonatomic,strong)YMTopReadView* topReadView;

@property(nonatomic,strong)AVAudioPlayer* audioPlayer;

//存储每一个字
@property(nonatomic,strong)NSMutableArray* strLabelsArr;

//second  --  index
@property(nonatomic,assign)NSInteger second;
//倒计时
@property(nonatomic,assign)NSInteger totalSecond;

@property(nonatomic,strong)NSTimer* readTimer;
@property(nonatomic,strong)NSTimer* indexTimer;

//开始播放timer
@property(nonatomic,strong)NSTimer* beginTimer;

@property(nonatomic,strong)NSURL* videoUrl;

@end

@implementation FMFileVideoController

#pragma mark - lifeCycle
- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalSecond = 3;
    self.second = 0;
    //创建UI
    [self creatUI];
    
    //开始朗读
    [self playVoice];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_videoView.fmodel.recordState == FMRecordStateFinish) {
        [_videoView reset];
        //将颜色进行变成白色 -- 刷新数据
        for (JXTProgressLabel * label in self.strLabelsArr) {
            label.dispProgress = 0;
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
    [self.readTimer invalidate];
    self.readTimer = nil;
    
    [_indexTimer invalidate];
    _indexTimer = nil;
    
    [_beginTimer invalidate];
    _beginTimer = nil;
    
    [self.audioPlayer stop];
}
- (void)dealloc
{
    [_readTimer invalidate];
    _readTimer = nil;
    [_indexTimer invalidate];
    _indexTimer = nil;
    
    [_beginTimer invalidate];
    _beginTimer = nil;
}
#pragma mark - UI
-(void)creatUI {
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = WhiteColor;
    //开始朗读按钮
    self.topReadView.sd_layout.topSpaceToView(self.view, 20).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(TopViewHeight);
    [self.topReadView.readBtn setTitle:[NSString stringWithFormat:@"开始朗读%ldS",(long)self.totalSecond] forState:UIControlStateNormal];
    self.topReadView.readBtn.tag = 100;
    
    //添加 collectionView
    [self.view addSubview:self.collectionView];
    //调整高度 与topView的间距 = （总高度 - topView 高度 - 文本collection 高度） * 0.5
    CGFloat topMargin = ((SCREEN_HEGIHT - 1.25 * SCREEN_WIDTH) - (TopViewHeight + 20) - CollectionTextHeiht ) * 0.5;
    self.collectionView.sd_layout.topSpaceToView(self.topReadView, topMargin ).heightIs(CollectionTextHeiht);//- 5
    
    //注册
    [self.collectionView registerClass:[YMCollectionViewCell class] forCellWithReuseIdentifier:@"YMCollectionViewCell"];
    
    //添加 video 界面
    _videoView = [[FMFVideoView alloc] initWithFMVideoViewType:TypeCustom];
    _videoView.delegate = self;
    //刚开始录制按钮隐藏
    _videoView.progressView.hidden = YES;
    [self.view addSubview:_videoView];
    //切换摄像头
    [_videoView.fmodel turnCameraAction];
}

-(void)playVoice {
    //设置按钮背景色
    [self.topReadView.readBtn setBackgroundColor:NavBar_UnabelColor];
    self.topReadView.readBtn.tag = 100;
    self.topReadView.readBtn.enabled = NO;
    
    // 1.获取要播放音频文件的URL
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"music" withExtension:@"mp3"];
    // 2.创建 AVAudioPlayer 对象
    NSError* error;
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:&error];
    // 3.打印歌曲信息
    NSString *msg = [NSString stringWithFormat:@"音频文件声道数:%ld\n 音频文件持续时间:%g",self.audioPlayer.numberOfChannels,self.audioPlayer.duration];
    NSLog(@"%@   error == %@",msg,error.description);
    // 4.设置循环播放
    //   self.audioPlayer.numberOfLoops = -1;
    self.audioPlayer.delegate = self;
    // 5.开始播放
    [self.audioPlayer play];
    //开始变化文字颜色
    [self startChangeTextColor];
}
#pragma mark - 文字颜色处理 -- 第一次录制
-(void)startChangeTextColor{
    //开始按钮倒计时
    self.beginTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateStartBtn) userInfo:nil repeats:YES];
}

//开始朗读按钮 倒计时
-(void)updateStartBtn{
    self.totalSecond --;
    if (self.totalSecond == 0) {
        [self.beginTimer invalidate];
        self.beginTimer = nil;
        //开始字体变色
        [self textBeginRun];
        //字体变成开始朗读
        self.topReadView.readBtn.tag = 200;
        self.topReadView.readBtn.enabled = NO;
        [self.topReadView.readBtn setTitle:@"开始朗读" forState:UIControlStateNormal];
        return;
    }
    
    [self.topReadView.readBtn setTitle:[NSString stringWithFormat:@"开始朗读%ldS",(long)self.totalSecond] forState:UIControlStateNormal];
}

-(void)textBeginRun{
    self.second = 0;
    self.readTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(prpgressUpdate) userInfo:nil repeats:YES];
    
    self.indexTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(indexAdd) userInfo:nil repeats:YES];
}

-(void)indexAdd{
    self.second ++;
}

- (void)prpgressUpdate
{
    DDLog(@"index == %ld",(long)self.second);
    if (self.second > self.strLabelsArr.count - 1) {
        self.second = self.strLabelsArr.count - 1;
        [_readTimer invalidate];
        _readTimer = nil;
        [_indexTimer invalidate];
        _indexTimer = nil;
//        return;
    }
    JXTProgressLabel* label = self.strLabelsArr[self.second];
    label.dispProgress += 0.01 * 10 / 3;
    if (label.dispProgress >= 1) {
        label.dispProgress = 1;
    }
    DDLog(@"index == %ld",(long)self.second);
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"flag == %d 播放成功失败 ",flag);
    if (flag) {
        [self.audioPlayer stop];
         self.topReadView.readBtn.enabled = YES;
         _videoView.progressView.hidden = NO;
        [self.topReadView.readBtn setBackgroundColor:BlueBtnColor];
       // [self.topReadView.readBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        //播放完成 将文字 变灰
        //刷新数据
        for (JXTProgressLabel * label in self.strLabelsArr) {

            label.dispProgress = 0;
            // DDLog(@"label text == %@",label);
        }
//        [self.collectionView reloadData];
    }
}
/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
     NSLog(@"  播放出现错误 error == %@ ",error);
}

#pragma mark - FMFVideoViewDelegate
- (void)recordFinishWithvideoUrl:(NSURL *)videoUrl
{
    DDLog(@"录制成功了");
    _videoView.fmodel.recordState = FMRecordStateFinish;
    self.topReadView.readBtn.hidden = NO;
    [self.topReadView.readBtn setTitle:@"完成朗读" forState:UIControlStateNormal];
    self.topReadView.readBtn.tag = 300;
    self.videoUrl = videoUrl;
    //保存视频
    // [self convertVideoWithURL:videoUrl];
    //跳转到回放
    FMVideoPlayController *playVC = [[FMVideoPlayController alloc] init];
    playVC.videoUrl =  self.videoUrl;
  //  playVC.view.frame = CGRectMake(0, SCREEN_HEGIHT - SCREEN_WIDTH * 1.25, SCREEN_WIDTH, 1.25 * SCREEN_WIDTH);
    [self.navigationController pushViewController:playVC animated:NO];

}

- (void)dismissVC
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)startRecordDelegateAction{
    DDLog(@"开始录制点击了");
     
//    YMTimeController* yvc = [[YMTimeController alloc]init];
//    yvc.startRecordBlock = ^(BOOL isStart) {
//        [self.videoView.fmodel startRecord];
//        //再次软色
//        [self  textBeginRun];
//       //btn.hidden = YES;
//    };
//    [self presentViewController:yvc animated:NO completion:nil];
    
     self.topReadView.readBtn.hidden = YES;
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
    NSString *path = [self createVideoFilePath];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:outputFileURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    __weak __typeof(self)weakSelf = self;
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
    {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputURL = [[NSURL alloc] initFileURLWithPath:path];
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                    break;
                case AVAssetExportSessionStatusCancelled:
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    [weakSelf completeWithUrl:exportSession.outputURL];
//                    FMVideoPlayController *playVC = [[FMVideoPlayController alloc] init];
//                    playVC.videoUrl =  exportSession.outputURL;
//                    weakSelf.videoUrl = exportSession.outputURL;
//                    [weakSelf.navigationController pushViewController:playVC animated:nil];
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

#pragma mark -- UICollectionViewDataSource
/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tipsArr.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YMCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YMCollectionViewCell" forIndexPath:indexPath];
     cell.titleLabel.text = self.tipsArr[indexPath.row];
    
    //添加到数组
    if (![self.strLabelsArr containsObject:cell.titleLabel]) {
        if (cell.titleLabel != nil) {
            [self.strLabelsArr addObject:cell.titleLabel];
        }
    }
    return  cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout UICollectionViewDelegate
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(RowHeight, RowHeight);
}

/** section的margin*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第 %zd组 第%zd个",indexPath.section, indexPath.row);
}

#pragma mark -- lazy load
-(YMTopReadView *)topReadView{
    if (!_topReadView) {
        _topReadView = [YMTopReadView shareViewWithTipStr:@"请大声朗读以下文字" tapBlock:^(UIButton *btn) {
            DDLog(@"点击啦按钮");
            //开始播放
            if (btn.tag == 100) {
                [self playVoice];
                btn.enabled = NO;
            }//开始录制 开始朗读
            else if (btn.tag == 200) {
                YMTimeController* yvc = [[YMTimeController alloc]init];
                yvc.startRecordBlock = ^(BOOL isStart) {
                    [self.videoView.fmodel startRecord];
                    //再次软色
                    [self  textBeginRun];
                    btn.hidden = YES;
                };
                [self presentViewController:yvc animated:NO completion:nil];
            }//回放
            else if (btn.tag == 300){
                //正在录制 --- 停止录制
                if (self.videoView.fmodel.recordState == FMRecordStateRecording) {
                    [self.videoView.fmodel stopRecord];
                }else{
                    //已经停止录制的，将上次录制好的视频回放
                    FMVideoPlayController *playVC = [[FMVideoPlayController alloc] init];
                    playVC.videoUrl =  self.videoUrl;
                    //playVC.view.frame = CGRectMake(0, SCREEN_HEGIHT - SCREEN_WIDTH * 1.25, SCREEN_WIDTH, 1.25 * SCREEN_WIDTH);
                    [self.navigationController pushViewController:playVC animated:NO];
                }
            }
        }];
        [self.view addSubview:_topReadView];
    }
    return _topReadView;
}

-(NSMutableArray *)tipsArr{
    NSString* tips = @"本 人 自 愿 通 过 贷 吧 ， 向 其 合 作 机 构 申 请 贷 款 ， 遵 守 合 约 ， 同 意 上 报 征 信";
    if (!_tipsArr) {
        _tipsArr = [tips componentsSeparatedByString:@" "].mutableCopy;
    }
    return _tipsArr;
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumInteritemSpacing = 0;// 垂直方向的间距
        layout.minimumLineSpacing      = 0; // 水平方向的间距
        CGFloat totalHeight = SCREEN_HEGIHT - SCREEN_WIDTH * 1.25;
        //[YMHeightTools heightForText:tipStr fontSize:18 width:SCREEN_WIDTH];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, (totalHeight - CollectionTextHeiht) * 0.5  , SCREEN_WIDTH - 20, CollectionTextHeiht) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}
-(NSMutableArray *)strLabelsArr{
    if (!_strLabelsArr) {
        _strLabelsArr = [[NSMutableArray alloc]init];
    }
    return _strLabelsArr;
}

//-(void)playSystemVoice{
    //    // 1. 定义要播放的音频文件的URL
    //    NSURL *voiceURL = [[NSBundle mainBundle]URLForResource:@"music" withExtension:@".mp3"];
    //    // 2. 注册音频文件（第一个参数是音频文件的URL 第二个参数是音频文件的SystemSoundID）
    //    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(voiceURL),&ditaVoice);
    //    // 3. 为crash播放完成绑定回调函数
    //    AudioServicesAddSystemSoundCompletion(ditaVoice,NULL,NULL,(void*)completionCallback,NULL);
    //    // 4. 播放 ditaVoice 注册的音频 并控制手机震动
    //    AudioServicesPlayAlertSound(ditaVoice);
    ////        AudioServicesPlaySystemSound(ditaVoice);
    //    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); // 控制手机振动
//}
@end
