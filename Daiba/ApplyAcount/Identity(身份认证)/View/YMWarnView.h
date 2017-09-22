//
//  YMWarnView.h
//  Daiba
//
//  Created by YouMeng on 2017/7/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMWarnView : UIView

@property(nonatomic,copy)void(^tapBlock)(UILabel* label);


@property(nonatomic,copy)void(^detailBlock)(UIButton* btn);

@property (weak, nonatomic) IBOutlet UIImageView *warnImgView;

@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
//规范按钮
@property (weak, nonatomic) IBOutlet UIButton *standardBtn;


+(instancetype)shareViewWithIconStr:(NSString* )iconStr warnStr:(NSString* )warnStr tapBlock:(void (^)(UILabel* label))tapBlock;

-(YMWarnView*)modifyViewWithWarnView:(YMWarnView*)warnView iconStr:(NSString* )iconStr warnStr:(NSString* )warnStr tapBlock:(void (^)(UILabel* label))tapBlock;

@end
