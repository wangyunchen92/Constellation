//
//  YMTopReadView.h
//  Daiba
//
//  Created by YouMeng on 2017/8/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YMTopReadView : UIView

@property(nonatomic,copy)void(^tapBlock)(UIButton* btn);

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;


+(instancetype)shareViewWithTipStr:(NSString* )tipStr tapBlock:(void (^)(UIButton* btn))tapBlock;
@end
