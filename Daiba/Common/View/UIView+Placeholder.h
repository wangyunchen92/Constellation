//
//  UIView+Placeholder.h
//  挑食商家版
//
//  Created by duyong_july on 16/6/30.
//  Copyright © 2016年 赵振龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Placeholder)

//@property(nonatomic,strong)UIImageView* imgV;
//@property(nonatomic,strong)UILabel*     titleLabel;

+ (UIView*)placeViewWithPlaceImgStr:(NSString*)placeImgStr placeString:(NSString*)placeString;

//通用占位图
+ (UIView* )placeViewWhithFrame:(CGRect)frame  placeImgStr:(NSString*)placeImgStr placeString:(NSString*)placeString;
@end
