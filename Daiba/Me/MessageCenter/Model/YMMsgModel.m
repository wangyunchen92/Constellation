//
//  YMMsgModel.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMsgModel.h"
#import "YMHeightTools.h"


const CGFloat contentLabelFontSize = 12;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

@implementation YMMsgModel
@synthesize content = _content;

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath{
    [super setValue:value forKeyPath:keyPath];
}

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"img"] || [key isEqualToString:@"imgs"]) {
        NSString* imgsStr = self.imgs;
        if (self.imgs == nil) {
            imgsStr = self.img;
        }
        
        NSArray* imgsArr = [imgsStr componentsSeparatedByString:@","];
        
        //朋友圈图片高度
        _imgHeight = [YMHeightTools getHeighByImgsArr:imgsArr spaceX:78 margin:10 rightMarin:30];
        //DDLog(@"friend heigh === %f",_heigh);
        
        //活动图片高度
        _heigh = [YMHeightTools getHeighByImgsArr:imgsArr spaceX:30 margin:10 rightMarin:30];
        // DDLog(@"activity heigh === %f",_heigh);
    }
    
    if ([key isEqualToString:@"content"] ) {
        //朋友圈文字高度
        _contentHeight = [self.content  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 78 - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |
                          NSStringDrawingTruncatesLastVisibleLine  |
                          NSStringDrawingTruncatesLastVisibleLine
                                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}context:nil].size.height;
        
        //活动文字高度
        _textHeight = [self.content  boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |
                       NSStringDrawingTruncatesLastVisibleLine  |
                       NSStringDrawingTruncatesLastVisibleLine
                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:contentLabelFontSize]}context:nil].size.height;
        
    }
}

-(NSString* )content{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 15 - 10;
    CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
    if (textRect.size.height > maxContentLabelHeight) {
        _shouldShowMoreButton = YES;
    } else {
        _shouldShowMoreButton = NO;
    }
    _textHeight = textRect.size.height;
    return _content;
}

@end
