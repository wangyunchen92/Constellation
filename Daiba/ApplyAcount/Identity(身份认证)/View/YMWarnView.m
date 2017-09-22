//
//  YMWarnView.m
//  Daiba
//
//  Created by YouMeng on 2017/7/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWarnView.h"


@implementation YMWarnView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(warnLabelClick:)];
    self.warnLabel.userInteractionEnabled = YES;
    [self.warnLabel addGestureRecognizer:tap];
    
    //默认隐藏
    self.standardBtn.hidden = YES;
}

+(instancetype)shareViewWithIconStr:(NSString* )iconStr warnStr:(NSString* )warnStr tapBlock:(void (^)(UILabel* label))tapBlock{
    YMWarnView* warnView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    warnView.warnLabel.text = warnStr;
    
    if ([NSString isEmptyString:iconStr]) {
       warnView.warnImgView.image = [UIImage imageNamed:@"感叹"];
    }else{
       warnView.warnImgView.image = [UIImage imageNamed:iconStr];
    }
    warnView.tapBlock = tapBlock;
    
    return warnView;
}
-(void)warnLabelClick:(UITapGestureRecognizer*)tap{
    NSLog(@"点击了label");
    if (self.tapBlock) {
        self.tapBlock((UILabel*) tap.view);
    }
}

- (YMWarnView* )modifyViewWithWarnView:(YMWarnView*)warnView iconStr:(NSString* )iconStr warnStr:(NSString* )warnStr tapBlock:(void (^)(UILabel* label))tapBlock{
    warnView.warnLabel.text = warnStr;
    warnView.warnImgView.image = [UIImage imageNamed:iconStr];
    warnView.tapBlock = tapBlock;
    [YMTool addTapGestureOnView:warnView.warnLabel target:self selector:@selector(warnLabelClick:) viewController:nil];
    
    return warnView;
}
- (IBAction)standardBtnClick:(id)sender {
    NSLog(@"点击啦填写规范");
    if (self.detailBlock) {
        self.detailBlock(sender);
    }
}

@end
