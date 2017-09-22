//
//  YMTopReadView.m
//  Daiba
//
//  Created by YouMeng on 2017/8/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTopReadView.h"

@implementation YMTopReadView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [YMTool viewLayerWithView:self.readBtn cornerRadius:5 boredColor:ClearColor borderWidth:1];
}

+(instancetype)shareViewWithTipStr:(NSString* )tipStr tapBlock:(void (^)(UIButton* btn))tapBlock{
    YMTopReadView* warnView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    if (![NSString isEmptyString:tipStr]) {
        warnView.tipLabel.text = tipStr;
    }
    warnView.tapBlock = tapBlock;
    return warnView;
}

- (IBAction)readBtnClick:(id)sender {
    DDLog(@"点击啦 朗读按钮");
    if (self.tapBlock) {
        self.tapBlock(sender);
    }
    
}

@end
