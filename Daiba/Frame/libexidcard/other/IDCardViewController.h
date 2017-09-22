//
//  IDCardViewController.h
//  CertificatesRecognition
//
//  Created by 吕同生 on 16/12/19.
//  Copyright © 2016年 JimmyLTS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardCapture.h"

@protocol IDCardViewControllerDelagate <NSObject>

- (void)finishPickerImageWithPositiveImage:(UIImage *)positiveImage inverseImage:(UIImage *)inverseImage;

@end

@interface IDCardViewController : UIViewController<CardCaptureDelegate>
{
    unsigned char *_buffer;
}

@property (nonatomic, assign) id<IDCardViewControllerDelagate> finishDelegate;

@property (nonatomic, strong) UIImage *positiveImage;

@property (nonatomic, strong) UIImage *inverseImage;

@property (nonatomic, assign) BOOL isPositive;

@property (nonatomic, strong) CardCapture *capture;

@property (nonatomic, strong) UIView *cameraView;

@property (nonatomic, weak) id<IDCardViewControllerDelagate> delegate;

@property (nonatomic, assign) BOOL verify;

@end
