//
//  YMHeightTools.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BorrowModel.h"
#import "UserModel.h"


@interface YMHeightTools : NSObject

//单独计算图片的高度
+ (CGFloat)heightForImage:(UIImage *)image width:(CGFloat)kPhotoCell_Width;
//单独计算文本的高度
+ (CGFloat)heightForText:(NSString *)text  fontSize:(CGFloat)kFontSize  width:(CGFloat)kPhotoCell_Width;

//获取文字的宽度
+(CGFloat)widthForText:(NSString* )text fontSize:(CGFloat)fontSize;

//计算图片的宽度
+ (CGFloat)getImgWidthByImgsArr:(NSArray* )imgsArr spaceX:(CGFloat)spaceX margin:(CGFloat)margin  rightMarin:(CGFloat)rightMargin;

//计算图片数组 总的 高度
+ (CGFloat)getHeighByImgsArr:(NSArray* )imgsArr spaceX:(CGFloat)spaceX margin:(CGFloat)margin rightMarin:(CGFloat)rightMargin;


+ (CGFloat)getCellHeightWithUsrModel:(UserModel* )usrModel indexpath:(NSIndexPath* )indexPath;
@end
