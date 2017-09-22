
#import "THCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSFileManager+THAdditions.h"

//创建相册的通知
NSString *const THThumbnailCreatedNotification = @"THThumbnailCreated";
NSString *const videoQueueKey = @"cc.videoQueue";

@interface THCameraController () <AVCaptureFileOutputRecordingDelegate>

@property (strong, nonatomic) dispatch_queue_t videoQueue;//视频队列
@property (strong, nonatomic) AVCaptureSession *captureSession;//捕捉会话
@property (weak, nonatomic) AVCaptureDeviceInput *activeVideoInput;//输入
@property (strong, nonatomic) AVCaptureStillImageOutput *imageOutput;
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieOutput;
@property (strong, nonatomic) NSURL *outputURL;

@end

@implementation THCameraController

- (BOOL)setupSession:(NSError **)error {
    // CC_6
    //创建捕捉会话 AVCaptureSession 是捕捉场景的中心枢纽
    self.captureSession = [[AVCaptureSession alloc]init];
    /*
     AVCaptureSessionPresetPhoto
     AVCaptureSessionPresetHigh
     AVCaptureSessionPresetMedium
     AVCaptureSessionPresetLow
     AVCaptureSessionPreset320x240
     AVCaptureSessionPreset352x288
     AVCaptureSessionPreset640x480 -- 二维码 不需要太高的分辨率
     AVCaptureSessionPreset960x540
     AVCaptureSessionPreset960x540
     AVCaptureSessionPreset1280x720
     AVCaptureSessionPreset1920x1080
     */
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    //拿到默认视频捕捉设备。iOS系统返回后置 摄像头
    AVCaptureDevice* videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //将捕捉设备封装成 AVCaptureDeviceInput
    //为会话添加捕捉设备，必须将设备封装成AVCaptureDeviceInput对象
    AVCaptureDeviceInput * videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    //判断videoInput 是否有效
    if (videoInput) {
        if ([self.captureSession canAddInput:videoInput]) {
            // 将videoInput 添加到captureSession中
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        }
       
    }else{
        return NO;
    }
    //选择默认的音频 捕捉设备 返回一个内置的 麦克风
    AVCaptureDevice * audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //为这个设备 创建一个 捕捉设备 输入
    AVCaptureDeviceInput* audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:error];
    //判断是否有效
    if (audioInput) {
        //测试是否能添加到会话中
        if ([self.captureSession canAddInput:audioInput]) {
            //将audioInput 添加到 captureSession 中
            [self.captureSession addInput:audioInput];
        }
    }else{
        return NO;
    }
    
    //AVCaptureStillImageOutput 实例 从摄像头 捕捉静态图片
    self.imageOutput = [[AVCaptureStillImageOutput alloc]init];
    //配置字典 希望捕捉到JPEG 格式的图片
    self.imageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    //输出连接 判断是否可用，可用则添加到输出连接中去
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
    // 创建一个AVCaptureMovieFileOutput 实例，用于将 quick Time 电影录制到文件系统
    self.movieOutput = [[AVCaptureMovieFileOutput alloc]init];
    
    //输出连接，判断是否可用，可用 则添加到输出连接中去
    if ([self.captureSession canAddOutput:self.movieOutput]) {
        [self.captureSession addOutput:self.movieOutput];
    }
    self.videoQueue = dispatch_queue_create("cc.videoQueue", NULL);
    
    return YES;
}

- (void)startSession {
    // CC_7
    //检查是否处于 运行状态
    if (![self.captureSession isRunning]) {
        //使用同步调用会损耗一定到时间，则用异步的方式处理
        dispatch_async(self.videoQueue, ^{
            [self.captureSession startRunning];
        });
    }
    
}

- (void)stopSession {
    // CC_8
    //检查是否处于运行状态
    if ([self.captureSession isRunning]) {
        //使用异步停止运行
        dispatch_async(self.videoQueue, ^{
            [self.captureSession stopRunning];
        });
    }
}

#pragma mark - Device Configuration

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    // CC_9
    // 获取可用 视频设备
    NSArray * devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    // 遍历可用的视频设备 并返回position 参数值
    for (AVCaptureDevice *devc in devices) {
        if (devc.position == position) {
            return devc;
        }
    }
    return nil;
}
//激活的设备
- (AVCaptureDevice *)activeCamera {
    // CC_10
    return self.activeVideoInput.device;
}

- (AVCaptureDevice *)inactiveCamera {
    // CC_11
    //通过查找当前激活摄像头的 反向摄像头获得，如果设备只有一个摄像头，则返回nil
    AVCaptureDevice *device = nil;
    if (self.cameraCount > 1) {
        if ([self activeCamera].position == AVCaptureDevicePositionBack) {
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }else{
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}
// 判断是否有超过1个摄像头可用
- (BOOL)canSwitchCameras {

    // CC_12
    return self.cameraCount > 1;
}

- (NSUInteger)cameraCount {

    // CC_13
    
    return 0;
}

- (BOOL)switchCameras {

    // CC_14
    if (![self canSwitchCameras]) {
        return NO;
    }
    //获取当前设备的反向设备
    NSError * error;
    AVCaptureDevice* videoDevice = [self inactiveCamera];
    //将摄入设备封装成 AVCaptureDeviceInput
    AVCaptureDeviceInput * videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    //判断是否为videoInput nil
    if (videoInput) {
        // 标注原配置变化开始
        [self.captureSession beginConfiguration];
        //将捕捉会话中，原本的捕捉输入设备移除
        [self.captureSession removeInput:self.activeVideoInput];
        //判断新的设备是否能加入
        if ([self.captureSession canAddInput:videoInput]) {
            //能加入成功，则将videoInput 作为新的视频捕捉设备
            [self.captureSession addInput:videoInput];
            //将获得设备 改为 videoInput
            self.activeVideoInput = videoInput;
        }else{
            //如果新设备，无法加入。则将原本的视频捕捉设备重新加入到捕捉会话中
#warning todo - 新增
            if ([self.captureSession canAddInput:self.activeVideoInput]) {
                 [self.captureSession addInput:self.activeVideoInput];
            }
        }
        //配置完成后，AVCaptureSession commitConfiguration 会分批的将所有变更整合在一起
        [self.captureSession commitConfiguration];
        
    }else{
        //创建AVCaptureInput 出现错误，则通知委托来 处理改 错误
        return NO;
    }
    
    return YES;
}

#pragma mark - Focus Methods 点击聚焦方法的实现
- (BOOL)cameraSupportsTapToFocus {
    // CC_16
    //询问 激活中的摄像头 是否支持 兴趣点 对焦
    return [[self activeCamera] isFocusPointOfInterestSupported];
}

- (void)focusAtPoint:(CGPoint)point {
    // CC_17
    AVCaptureDevice *device = [self activeCamera];
    //是否支持兴趣点 对焦 & 是否自动对焦模式
    if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError* error;
        //锁定设备 准备配置 ，如果获得了锁
        if ([device lockForConfiguration:&error]) {
            // 将focusPointOfInterest 属性 设置 CGPoint
             device.focusPointOfInterest = point;
            
            // focusMode 设置为 AVCaptureFocusModeAutoFocus
            device.focusMode = AVCaptureFocusModeAutoFocus;
            // 释放锁定
            [device unlockForConfiguration];
        }else{
          //错误时，则返回给错误代理处理
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}

#pragma mark - Exposure Methods 点击曝光的方法实现

- (BOOL)cameraSupportsTapToExpose {
    // CC_18
    //询问设备 是否支持对 一个兴趣点 进行曝光
    return [[self activeCamera] isExposurePointOfInterestSupported];
}

static const NSString * THCameraAdjustingExposureContext;
- (void)exposeAtPoint:(CGPoint)point {
    // CC_19
    AVCaptureDevice* device = [self activeCamera];
    // 连续曝光
    AVCaptureExposureMode exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    //判断 是否支持 AVCatureExposureModecontinuousAutoExposure 模式
    if (device.isExposurePointOfInterestSupported && [device isExposureModeSupported:exposureMode]) {
        [device isExposureModeSupported:exposureMode];
        
        NSError* error;
        //锁定设备 准备配置
        if ([device lockForConfiguration:&error]) {
            //配置期望值
            device.exposureMode = exposureMode;
            device.exposurePointOfInterest = point;
            
            //判断 设备是否 支持 锁定 曝光模式
            if ([device isExposureModeSupported:AVCaptureExposureModeLocked]) {
                //支持，则使用 kvo 确定设备的 adjustingExposure 属性的状态
                [device addObserver:self forKeyPath:@"adjustingExposure" options:NSKeyValueObservingOptionNew context:&THCameraAdjustingExposureContext];
            }
            //释放锁定
            [device unlockForConfiguration];
        }else{
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}
// kvo
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    // CC_20
    //判断context 上下文 ，是否为 THCameraAdjustingExposureContext
    if (context == &THCameraAdjustingExposureContext) {
        //获取device
        AVCaptureDevice *device = (AVCaptureDevice* )object;
        //判断设备是否 不再调整 曝光等级 ，确认设备的 exposureMode
        //是否可以设置为 AVCaptureExposureModeLocked
        if (!device.isAdjustingExposure && [device isExposureModeSupported:AVCaptureExposureModeLocked]) {
            //移除 作为 adjustingExposure 的 self ，就不会得到后续变更的通知
            [object removeObserver:self forKeyPath:@"adjustingExposure" context:&THCameraAdjustingExposureContext];
            
            //异步方式调回主队列
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError * error;
                if ([device lockForConfiguration:&error]) {
                    //修改 exposureMode
                    device.exposureMode = AVCaptureExposureModeLocked;
                    //释放该锁定
                    [device unlockForConfiguration];
                }else{
                    [self.delegate deviceConfigurationFailedWithError:error];
                }
            });
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}
//重新 设置 对焦 & 曝光
- (void)resetFocusAndExposureModes {
    // CC_21
    AVCaptureDevice* device = [self activeCamera];
    AVCaptureFocusMode focusMode = AVCaptureFocusModeContinuousAutoFocus;
    //获取对焦 兴趣点 和 连续自动对焦模式 是否被支持
    BOOL canResetFocus = [device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode];
    AVCaptureExposureMode exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    // 确认曝光度  可以被重设
    BOOL canResetExposure = [device isExposureModeSupported:exposureMode] && [device isExposurePointOfInterestSupported];
    //回顾一下，捕捉设备空间左⬆️角（0，0） 右下角（1，1） 中心点（0.5，0.5）
    CGPoint centerPoint = CGPointMake(0.5f, 0.5f);
    NSError *error;
    //绑定设备，准备配置
    if ([device lockForConfiguration:&error]) {
        //焦点可设，则修改
        if (canResetFocus) {
            device.focusMode = focusMode;
            device.focusPointOfInterest = centerPoint;
        }
        //曝光度可设，则设置为期望的曝光模式
        if (canResetExposure) {
            device.exposureMode = exposureMode;
            device.exposurePointOfInterest = centerPoint;
        }
      
      //释放锁定
        [device unlockForConfiguration];
    }else{
        [self.delegate deviceConfigurationFailedWithError:error];
    }
}

#pragma mark - Flash and Torch Modes - 闪光灯 和 手电筒
//判断是否有闪光灯
- (BOOL)cameraHasFlash {
    // CC_22
    return [[self activeCamera] hasFlash];
}

// 闪光灯模式
- (AVCaptureFlashMode)flashMode {
    // CC_23
    return [[self activeCamera] flashMode];
}
//设置闪光灯模式
- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    // CC_24
    AVCaptureDevice *device = [self activeCamera];
    if ([device isFlashModeSupported:flashMode]) {
        NSError  * error;
        if ([device lockForConfiguration:&error]) {
            
            device.flashMode = flashMode;
            [device unlockForConfiguration];
        }else{
            
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}
//是否支持手电筒
- (BOOL)cameraHasTorch {
    // CC_25
    return [[self activeCamera] hasTorch];
}
//手电筒模式
- (AVCaptureTorchMode)torchMode {
    // CC_26
    return [[self activeCamera] torchMode];
}
//设置打开手电筒
- (void)setTorchMode:(AVCaptureTorchMode)torchMode {
    // CC_27
    AVCaptureDevice *device = [self activeCamera];
    if ([device isTorchModeSupported:torchMode]) {
        NSError  * error;
        if ([device lockForConfiguration:&error]) {
            
            device.torchMode = torchMode;
            [device unlockForConfiguration];
        }else{
            
            [self.delegate deviceConfigurationFailedWithError:error];
        }
    }
}


#pragma mark - Image Capture Methods - 拍摄静态图片
//AVCaptureStillImageOutput 是 AVCaptureOutput 的子类，用于捕捉图片
- (void)captureStillImage {
    // CC_28  获取连接
    AVCaptureConnection* connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    //程序只支持 纵向，如果用户横向拍照时，需要调整结果 照片的方向
    //判断 是否支持 设置 视频方向
    if (connection.isVideoOrientationSupported) {
        //获取方向值
        connection.videoOrientation = [self currentVideoOrientation];
    }
    //定义一个handle 块，会返回一个图片的 NSData 数据
    id handler = ^(CMSampleBufferRef sampleBuffer,NSError * error){
        
        if (sampleBuffer != NULL) {
            NSData * imgData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
            UIImage * image = [[UIImage alloc]initWithData:imgData];
            
            //重点：捕捉照片成功后，将图片传递出去
            [self writeImageToAssetsLibrary:image];
        }else{
            NSLog(@"NULL sampleBuffer: %@",[error localizedDescription]);
        }
    };
    //捕获 静态图片
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:handler];
}

//获取当前的方向值
- (AVCaptureVideoOrientation)currentVideoOrientation {
    // CC_29
    // CC_30
    AVCaptureVideoOrientation orientation;
    //获取UIDevice 的 orientation
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
            
        default:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    return orientation;
}

//ASSets Library 框架。会访问相册
- (void)writeImageToAssetsLibrary:(UIImage *)image {
    // CC_31
    //创建ALAssetsLibrary 实例
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc]init];
    //参数1:图片 参数为 CGImageRef。 image.CGImage
    //参数2:方向参数 转为 NSUInteger
    //参数3:写入成功、失败处理
     [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(NSUInteger)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
         //成功后，发送捕捉图片通知，用于绘制程序 左下角的缩略图
         if (!error) {
             [self postThumbnailNotifification:image];
         }else{
             //失败打印错误信息
             id message = [error localizedDescription];
             NSLog(@"存储照片 error == %@ ",message);
         }
     }];
}

- (void)postThumbnailNotifification:(UIImage *)image {
    // CC_32
    // 回到主队列
    dispatch_async(dispatch_get_main_queue(), ^{
       //发送请求
     [[NSNotificationCenter defaultCenter] postNotificationName:THThumbnailCreatedNotification object:image];
    });
    
}

#pragma mark - Video Capture Methods
//判断是否录制状态
- (BOOL)isRecording {
    // CC_33
    return self.movieOutput.isRecording;
}
//开始录制
- (void)startRecording {
    // CC_34
    if (![self isRecording]) {
        //获取当前视频捕捉 连接信息，用于捕捉视频数据 配置一些 核心属性
        AVCaptureConnection * videoConnection = [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
        //判断是否支持videoOrientation 属性
        if ([videoConnection isVideoOrientationSupported]) {
            //支持则修改 当前视频的方向
            videoConnection.videoOrientation = [self currentVideoOrientation];
        }
        //判断是否支持视频稳定 可以提高视频的质量 只会在录制视频文件 涉及
        if ([videoConnection isVideoStabilizationSupported]) {
            videoConnection.enablesVideoStabilizationWhenAvailable = YES;
        }
        AVCaptureDevice *device = [self activeCamera];
        //摄像头可以进行 平滑对焦模式操作，即减慢摄像头 对焦速度。当用户移动拍摄时 摄像头 会尝试 快速自动对焦
        if (device.isSmoothAutoFocusSupported) {
            NSError* error;
            if ([device lockForConfiguration:&error]) {
                device.smoothAutoFocusEnabled = YES;
                [device unlockForConfiguration];
            }else{
                [self.delegate deviceConfigurationFailedWithError:error];
            }
        }
        
        //查找写入捕捉视频的唯一 文件系统URL
        self.outputURL = [self uniqueURL];
        //在捕捉输出上 调用方法 参数1:录制保存路径。参数2：代理
        [self.movieOutput startRecordingToOutputFileURL:self.outputURL recordingDelegate:self];
    }
}
//录制的时间长度
- (CMTime)recordedDuration {
    return self.movieOutput.recordedDuration;
}

//写入视频 唯一文件系统 URL
- (NSURL *)uniqueURL {
    // CC_35
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //可以将文件写入的目的 创建一个唯一的 命名目录
    NSString* dirPath = [fileManager temporaryDirectoryWithTemplateString:[NSString stringWithFormat:@"%@",[NSDate date]]];
    if (dirPath) {
        NSString* filePath = [dirPath stringByAppendingString:@"kamera_movie.mov"];
        
        return [NSURL fileURLWithPath:filePath];
    }
    
    return nil;
}
//停止录制
- (void)stopRecording {
    // CC_36
    //是否正在录制
    if ([self isRecording]) {
        [self.movieOutput stopRecording];
    }
    
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error {
    // CC_37
    if (error) {
        [self.delegate mediaCaptureFailedWithError:error];
    }else{
        //写入
        [self writeVideoToAssetsLibrary:[self.outputURL copy]];
    }
    
    self.outputURL = nil;
}
//写入 捕捉到的视频
- (void)writeVideoToAssetsLibrary:(NSURL *)videoURL {
    // CC_38
    // ALAssetsLibrary  实例 提供写入视频的接口
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc]init];
    // 写资源库写入前，检查是否可被写入，写入前尽量养成判断的习惯
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:videoURL]) {
        //创建block
        ALAssetsLibraryWriteVideoCompletionBlock completionBlock;
        completionBlock = ^(NSURL* assetURL,NSError* error){
            if (error) {
                [self.delegate assetLibraryWriteFailedWithError:error];
            }else{
                //用于界面展示视频缩略图
                [self generateThumbnailForVideoAtURL:videoURL];
            }
        };
        
        //执行 实际写入资源库 的动作
        [library writeVideoAtPathToSavedPhotosAlbum:videoURL completionBlock:completionBlock];
    }
}

// 获取视频 左下角 缩略图
- (void)generateThumbnailForVideoAtURL:(NSURL *)videoURL {
    // CC_39
    //在 videoQueue 上
    dispatch_async(self.videoQueue, ^{
        //建立新的 AVAsset & AVAssetImageGenerator
        AVAsset* asset = [AVAsset assetWithURL:videoURL];
        AVAssetImageGenerator* imageGenetator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        //设置 maximunSize 宽度为100，高为0 根据视频的宽高比 来计算图片的 宽带
        imageGenetator.maximumSize = CGSizeMake(100.0f, 0.0f);
        //捕捉视频缩略图 会考虑视频的变化 （eg 视频的方向变化），如果不设置，缩略图的方向 可能出错
        imageGenetator.appliesPreferredTrackTransform = YES;
        
        NSError* error;
        //获取CGImage 图片。注意需要自己管理它的创建和释放
        CGImageRef imageRef = [imageGenetator copyCGImageAtTime:kCMTimeZero actualTime:NULL error:&error];
        
        // 将图片转化为 UIImage
        UIImage* image = [UIImage imageWithCGImage:imageRef];
        //释放CGImageRef  imageRef 防止内存释放
        CGImageRelease(imageRef);
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //发送通知，传递最新的image
            [self postThumbnailNotifification:image];
        });
    });
}

@end

