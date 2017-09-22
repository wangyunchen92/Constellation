//
//  YMBottomView.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMBottomView.h"


@implementation YMBottomView

- (instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray* )titlesArr backGgColorsArr:(NSArray* )backGgColorsArr taskBlock:(void (^)(UIButton* btn))taskBlock{
    if (self = [super initWithFrame:frame]) {
        CGFloat marginY = 5;
        CGFloat marginX = 15;
        CGFloat width  = (frame.size.width - 2 * marginX) / titlesArr.count;
        CGFloat height = frame.size.height - 2 * marginY;
        
        self.backgroundColor = BackGroundColor;
        CGFloat x = marginX;
        for (int i = 0; i < titlesArr.count; i ++) {
            UIButton* btn = [[UIButton alloc]init];
            [self addSubview:btn];
            
            btn.backgroundColor = [UIColor colorwithHexString:backGgColorsArr[i]];
            [btn setTitleColor:[UIColor colorwithHexString:@"FFFFFF"] forState:UIControlStateNormal];//
            btn.layer.cornerRadius = 2;
            btn.clipsToBounds = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.titleLabel.textColor = RedColor;
            [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.tag = i;
          
            self.taskBlock = taskBlock;
            [btn addTarget:self action:@selector(taskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.sd_layout.xIs(x).topSpaceToView(self,marginY).yIs(marginY).widthIs(width).heightIs(height);
            x += width;
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray* )titlesArr bgColorsHexStrArr:(NSArray* )bgColorsHexStrArr textColor:(UIColor*)textColor  selectColor:(UIColor*)selectColor taskBlock:(void (^)(UIButton* btn))taskBlock{
    if (self = [super initWithFrame:frame]) {
        CGFloat marginY = 0;
        CGFloat marginX = 0;
        CGFloat width  = (frame.size.width - 2 * marginX) / titlesArr.count;
        CGFloat height = frame.size.height - 2 * marginY;
        
        self.backgroundColor = BackGroundColor;
        CGFloat x = marginX;
        for (int i = 0; i < titlesArr.count; i ++) {
            UIButton* btn = [[UIButton alloc]init];
            [self addSubview:btn];
            
            btn.backgroundColor = [UIColor colorwithHexString:bgColorsHexStrArr[i]];
            [btn setTitleColor:textColor forState:UIControlStateNormal];//
            [btn setTitleColor:selectColor forState:UIControlStateSelected];
            btn.layer.cornerRadius = 2;
            btn.clipsToBounds = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            //btn.titleLabel.textColor = RedColor;
            [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.tag = i;
            btn.selected = NO;
            self.taskBlock = taskBlock;
            [btn addTarget:self action:@selector(taskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.sd_layout.xIs(x).topSpaceToView(self,marginY).yIs(marginY).widthIs(width).heightIs(height);
            x += width;
            
        }
        UIView* lineView = [[UIView alloc]init];
        lineView.backgroundColor = BackGroundColor;
        [self addSubview:lineView];
        
        lineView.sd_layout.centerXEqualToView(self).centerYEqualToView(self).heightIs(30).widthIs(1);
        
    }
    return self;
}

-(void)taskBtnClick:(UIButton* )btn{
    DDLog(@"按钮点击啦");
    if (self.taskBlock) {
        self.taskBlock(btn);
    }
}
@end
