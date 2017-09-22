//
//  ShareButton.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/14.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "ShareButton.h"

@implementation ShareButton

- (instancetype)initWithFrame:(CGRect)frame imgStr:(NSString* )imgStr title:(NSString* )title{
    self = [super initWithFrame:frame];
    if (self) {
        // 27 * 35
        CGFloat width = frame.size.width;
        // CGFloat height = frame.size.height;
        
        _imagView = [[UIImageView alloc]initWithFrame:CGRectMake((width - 40)/2,15,40,40)];
        [_imagView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _imagView.contentMode = UIViewContentModeScaleAspectFit;
        
        //待修改
        _titlLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_imagView.frame) + 10,width,20)];
        _titlLabel.textAlignment = NSTextAlignmentCenter;
        _titlLabel.font = [UIFont systemFontOfSize:14];
        _titlLabel.text = title;
        _titlLabel.textColor = BlackColor ;
        
    }
    [self addSubview:_imagView];
    [self addSubview:_titlLabel];
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _imagView.sd_layout.centerYEqualToView(self);
    
}
@end
