
#import <AVFoundation/AVFoundation.h>

extern NSString * const THThumbnailCreatedNotification;

@protocol THCameraControllerDelegate <NSObject>

// CC_1  发生错误事件 需要在对象委托上 调用一些方法来处理
- (void)deviceConfigurationFailedWithError:(NSError *)error;
- (void)mediaCaptureFailedWithError:(NSError *)error;
- (void)assetLibraryWriteFailedWithError:(NSError *)error;
@end

@interface THCameraController : NSObject

@property (weak, nonatomic) id<THCameraControllerDelegate> delegate;
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;

// Session Configuration 用于设置 配置视频捕捉会话
// CC_2
- (BOOL)setupSession:(NSError **)error;
- (void)startSession;
- (void)stopSession;

// Camera Device Support  切换不同的摄像头
// CC_3
- (BOOL)switchCameras;
- (BOOL)canSwitchCameras;
@property (nonatomic, readonly) NSUInteger cameraCount;
@property (nonatomic, readonly) BOOL cameraHasTorch;//手电筒
@property (nonatomic, readonly) BOOL cameraHasFlash;//闪光灯
@property (nonatomic, readonly) BOOL cameraSupportsTapToFocus;//聚焦
@property (nonatomic, readonly) BOOL cameraSupportsTapToExpose;//曝光
@property (nonatomic) AVCaptureTorchMode torchMode;//手电筒模式
@property (nonatomic) AVCaptureFlashMode flashMode;//闪光灯模式

// Tap to * Methods
//聚焦曝光 重设聚焦曝光方法
// CC_4
- (void)focusAtPoint:(CGPoint)point;
- (void)exposeAtPoint:(CGPoint)point;
- (void)resetFocusAndExposureModes;

/** Media Capture Methods **/
// CC_5  实现捕捉静态图片 & 视频的功能
// Still Image Capture
- (void)captureStillImage;

// Video Recording。视频录制
//开始录制
- (void)startRecording;
- (void)stopRecording;
- (BOOL)isRecording;
//录制时间
- (CMTime)recordedDuration;

@end
