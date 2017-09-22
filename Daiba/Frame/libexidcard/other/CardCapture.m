//
//  CardCapture.m
//  RecognizeIdCard
//
//  Created by 吕同生 on 16/12/16.
//  Copyright © 2016年 JimmyLTS. All rights reserved.
//

#import "CardCapture.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation CardCapture
{
    unsigned char* _buffer;
    IdCardInfo * _lastIdInfo;
}

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.captureSession = [[AVCaptureSession alloc] init];
        
        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
        
        self.outputSetting = [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
        
        self.verify = YES;
    }
    return self;
}

#pragma mark - public function
- (void)addVideoPreviewLayer {
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (void)addVideoInput:(AVCaptureDevicePosition)devicePosition {
    __block AVCaptureDevice *captureDevice = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    if (devicePosition == AVCaptureDevicePositionBack) {
        [devices enumerateObjectsUsingBlock:^(AVCaptureDevice *device, NSUInteger idx, BOOL * _Nonnull stop) {
            if (device.position == AVCaptureDevicePositionBack) {
                if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                    NSError *error = nil;
                    if ([device lockForConfiguration:&error]) {
                        device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                        [device unlockForConfiguration];
                    }
                }
                captureDevice = device;
                *stop = YES;
            }
        }];
    }else if (devicePosition == AVCaptureDevicePositionFront) {
        [devices enumerateObjectsUsingBlock:^(AVCaptureDevice *device, NSUInteger idx, BOOL * _Nonnull stop) {
            if (device.position == AVCaptureDevicePositionFront) {
                if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                    NSError *error = nil;
                    if ([device lockForConfiguration:&error]) {
                        device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                        [device unlockForConfiguration];
                    }
                }
                captureDevice = device;
            }
        }];
    }else
        NSLog(@"Error setting camera device position.");
    
    if (captureDevice) {
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        
        if (!error) {
            if ([self.captureSession canAddInput:deviceInput]) {
                [self.captureSession addInput:deviceInput];
            }else {
                NSLog(@"Couldn't add video input");
            }
        }else {
            NSLog(@"Couldn't create video input");
        }
    }else {
        NSLog(@"Couldn't create video capture device");
    }
    
}

- (void)addVideoOutput {
    AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [self.captureSession addOutput:dataOutput];
    
    dataOutput.videoSettings = [NSDictionary dictionaryWithObject:_outputSetting forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    dataOutput.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t queue = dispatch_queue_create("muQueue", NULL);
    [dataOutput setSampleBufferDelegate:self queue:queue];
}

#pragma mark - private function

- (void)addStillImageOutput {
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    NSDictionary *outputSetting = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    self.stillImageOutput.outputSettings = outputSetting;
    
    AVCaptureConnection *captureConnection = nil;
    
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in connection.inputPorts)
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                captureConnection = connection;
                break;
            }
        }
        if (captureConnection)
        {
            captureConnection.videoMinFrameDuration = CMTimeMake(1, 15);
            break;
        }
    }
    
    [self.captureSession addOutput:self.stillImageOutput];
    
}

- (void)captureStillImage
{
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections])
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    static int n = 0;
    if (++n % 2)
        return;
    
    if ([_outputSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]] ||
        [_outputSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]]  )
    {
        if([self.delegate respondsToSelector:@selector(idCardRecognited:)])
        {
            IdCardInfo *idInfo = [self idCardRecognit:sampleBuffer];
            if (idInfo !=nil && [idInfo isOK])
            {
                [self.delegate idCardRecognited:idInfo];
            }
        }
    }
    else
    {
        NSLog(@"Error output video settings");
    }
}

- (IdCardInfo *)idCardRecognit:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    IdCardInfo *idInfo = nil;
    // Lock the image buffer
    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
    {
        size_t width= CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        CVPlanarPixelBufferInfo_YCbCrBiPlanar *planar = CVPixelBufferGetBaseAddress(imageBuffer);
        size_t offset = NSSwapBigIntToHost(planar->componentInfoY.offset);
        size_t rowBytes = NSSwapBigIntToHost(planar->componentInfoY.rowBytes);
        unsigned char* baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
        unsigned char* pixelAddress = baseAddress + offset;
        if (_buffer == NULL)
            _buffer = (unsigned char*)malloc(sizeof(unsigned char) * width * height);
        
        memcpy(_buffer, pixelAddress, sizeof(unsigned char) * width * height);
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        
        unsigned char pResult[1024];
        
        
        int ret = EXCARDS_RecoIDCardData(_buffer, (int)width, (int)height, (int)rowBytes, (int)8, (char*)pResult, sizeof(pResult));
        if (ret <= 0)
        {
            NSLog(@"IDCardRecApi，ret[%d]", ret);
        }
        else
        {
            NSLog(@"ret=[%d]", ret);
            char ctype;
            char content[256];
            int xlen;
            int i = 0;
            
            idInfo = [[IdCardInfo alloc] init];
            ctype = pResult[i++];
            idInfo.type = ctype;
            while(i < ret){
                ctype = pResult[i++];
                for(xlen = 0; i < ret; ++i){
                    if(pResult[i] == ' ') { ++i; break; }
                    content[xlen++] = pResult[i];
                }
                content[xlen] = 0;
                if(xlen){
                    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    if(ctype == 0x21)
                        idInfo.code = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    else if(ctype == 0x22)
                        idInfo.name = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    else if(ctype == 0x23)
                        idInfo.gender = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    else if(ctype == 0x24)
                        idInfo.nation = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    else if(ctype == 0x25)
                        idInfo.address = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    else if(ctype == 0x26)
                        idInfo.issue = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    else if(ctype == 0x27)
                        idInfo.valid = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                }
            }
            if (self.verify)
            {
                if (_lastIdInfo == nil)
                {
                    _lastIdInfo = idInfo;
                    idInfo = nil;
                }
                else
                {
                    if (![_lastIdInfo isEqual:idInfo])
                    {
                        _lastIdInfo = idInfo;
                        idInfo = nil;
                    }
                }
            }
            if ([idInfo isOK])
            {
                //NSLog(@"[%@]", [idInfo toString]);
            }
        }
    }
    
    return idInfo;
}

- (NSString *)documentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - Dealloc

- (void)dealloc
{
    [self.captureSession stopRunning];
    
    _previewLayer = nil;
    _captureSession = nil;
    _stillImageOutput = nil;
    _stillImage = nil;
    _outputSetting = nil;
    _delegate = nil;
}


@end
