//
//  XFStepView.h
//  SCPay
//
//  Created by weihongfang on 2017/6/26.
//  Copyright © 2017年 weihongfang. All rights reserved.
//

#import <UIKit/UIKit.h>


#define TINTCOLOR [UIColor colorWithRed:0/255.f green:145/255.f blue:255/255.f alpha:1]

#define FailureCOLOR [UIColor colorWithRed:246/255.f green:71/255.f blue:71/255.f alpha:1]


#define unSelectColor [UIColor lightGrayColor]

#define TitleTextColor [UIColor lightGrayColor]

@interface XFStepView : UIView

@property (nonatomic, retain)NSArray * _Nonnull titles;


@property(nonatomic,assign)BOOL isFailure;

@property (nonatomic, assign)int stepIndex;

@property (nonatomic, strong)NSMutableArray * _Nullable cricleMarks;

@property (nonatomic, strong)NSMutableArray * _Nullable titleLabels;

- (instancetype _Nonnull )initWithFrame:(CGRect)frame Titles:(nonnull NSArray *)titles;

- (void)setStepIndex:(int)stepIndex Animation:(BOOL)animation;

@end
