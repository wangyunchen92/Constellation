//
//  YMTextField.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/17.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTextField.h"

@implementation YMTextField

-(CGRect)textRectForBounds:(CGRect)bounds {
    bounds.origin.x += 15;
    return bounds;
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    bounds.origin.x += 15;
    return bounds;
}
- (CGRect)editingRectForBounds:(CGRect)bounds{
    bounds.origin.x += 15;
    return bounds;
}

//-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
//{
//    CGRect frame = textField.frame;
//    frame.size.width = leftWidth;
//    UIView *leftview = [[UIView alloc] initWithFrame:frame];
//    textField.leftViewMode = UITextFieldViewModeAlways;
//    textField.leftView = leftview;
//}
@end
