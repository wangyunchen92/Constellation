//
//  UIView+Placeholder.m
//  挑食商家版
//
//  Created by duyong_july on 16/6/30.
//  Copyright © 2016年 赵振龙. All rights reserved.
//

#import "UIView+Placeholder.h"


@implementation UIView (Placeholder)

+ (UIView*)placeViewWithPlaceImgStr:(NSString*)placeImgStr placeString:(NSString*)placeString {
    
    CGFloat width = 96;
    CGFloat height = 128 + 40;
    
    UIView *placeView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - width)/2, (SCREEN_HEGIHT - height - 100)/2, width, height)];
    
    UIImageView* imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 96, 128)];
    imgV.image = [UIImage imageNamed:placeImgStr];
    
    UILabel * titileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame) + 10, width, 30)];
    titileLabel.textAlignment = NSTextAlignmentCenter;
    titileLabel.font = [UIFont systemFontOfSize:17];
    titileLabel.textColor = LightGrayColor;
    titileLabel.text = placeString;
    
    //添加
    [placeView addSubview:imgV];
    [placeView addSubview:titileLabel];
    return placeView;
}
+ (UIView* )placeViewWhithFrame:(CGRect)frame  placeImgStr:(NSString*)placeImgStr placeString:(NSString*)placeString{
    
    CGFloat width  = frame.size.width/4;
    CGFloat height = frame.size.height/4;

    CGFloat  x = (frame.size.width - width)/2;
    CGFloat  y = (frame.size.height - height)/2 - 30;
    
    UIView *placeView = [[UIView alloc]initWithFrame:CGRectMake(x,y , width, height)];

    UIImageView* imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, width, width)];//width * 1/3 , (height - width * 1/3) /2 - 50
    imgV.image = [UIImage imageNamed:placeImgStr];
    
    UILabel * titileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame) + 20, width, 30)];
    titileLabel.textAlignment = NSTextAlignmentCenter;
    titileLabel.font = Font(14);
    titileLabel.textColor = LightGrayColor;
    titileLabel.text = placeString;
    //调整消息 宽度 和 居中
    CGSize size = [placeString sizeWithAttributes:@{NSFontAttributeName:Font(14)}];
    titileLabel.width = size.width;
    
    titileLabel.x = (width - size.width)/2;
    //添加
    [placeView addSubview:imgV];
    [placeView addSubview:titileLabel];
    return placeView;


}
//-(void)layoutSubviews{
////    [super layoutSubviews];
//    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height;
//
//    self.imgV.frame = CGRectMake(width * 1/3 , (height - width * 1/3) /2 - 50, width * 1/3, width * 1/3);
//
//    CGFloat y = CGRectGetMaxY(self.imgV.frame)+20;
//    self.titleLabel.frame = CGRectMake(width * 1/3, y, width * 1/3, 20);
//    
//}


@end
