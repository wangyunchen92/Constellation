//
//  CardCapture.h
//  RecognizeIdCard
//
//  Created by 吕同生 on 16/12/16.
//  Copyright © 2016年 JimmyLTS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "excards.h"
#import "IdCardInfo.h"

@protocol CardCaptureDelegate <NSObject>

- (void)idCardRecognited:(IdCardInfo *)idInfo;

@end

@interface CardCapture : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) UIImage *stillImage;

@property (nonatomic, strong) NSNumber *outputSetting;

@property (nonatomic, weak) id<CardCaptureDelegate> delegate;

@property (nonatomic, assign) BOOL verify;

- (void)addVideoInput:(AVCaptureDevicePosition)devicePosition;

- (void)addVideoOutput;

- (void)addVideoPreviewLayer;

@end
