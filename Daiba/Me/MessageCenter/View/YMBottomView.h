//
//  YMBottomView.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YMBottomView : UIView

@property(nonatomic,copy)void(^taskBlock)(UIButton* btn);


//创建普通的view  例如消息底部的view
- (instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray* )titlesArr bgColorsHexStrArr:(NSArray* )bgColorsHexStrArr textColor:(UIColor*)textColor  selectColor:(UIColor*)selectColor taskBlock:(void (^)(UIButton* btn))taskBlock;

- (instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray* )titlesArr backGgColorsArr:(NSArray* )backGgColorsArr taskBlock:(void (^)(UIButton* btn))taskBlock;

@end
