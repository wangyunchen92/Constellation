//
//  YMBankUnsetCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/11.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMBankUnsetCell.h"

@interface YMBankUnsetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@end

@implementation YMBankUnsetCell

- (void)awakeFromNib {
    [super awakeFromNib];
#warning toto - 拉伸图片
    // 加载图片
//    UIImage *image = [UIImage imageNamed:@"bg"];
////方法一
////    // 设置左边端盖宽度
//    NSInteger leftCapWidth = image.size.width * 0.5;
//    // 设置上边端盖高度
//   NSInteger topCapHeight = image.size.height * 0.5;
//
////    resizableImageWithCapInsets
//    UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
// 方法二
    // 设置端盖的值
//    CGFloat top = image.size.height * 0.5;
//    CGFloat left = image.size.width * 0.5;
//    CGFloat bottom = image.size.height * 0.5;
//    CGFloat right = image.size.width * 0.5;
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
//    // 拉伸图片
//    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets];

//方法三
    // 设置端盖的值
//    CGFloat top = image.size.height * 0.5;
//    CGFloat left = image.size.width * 0.5;
//    CGFloat bottom = image.size.height * 0.5;
//    CGFloat right = image.size.width * 0.5;
//    
//    // 设置端盖的值
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
//    // 设置拉伸的模式
//    UIImageResizingMode mode = UIImageResizingModeStretch;
//    
//    // 拉伸图片
//    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
  
    // 设置按钮的背景图片
//    _bgImgView.image = newImage;
    
 }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)addBtnClick:(id)sender {
    DDLog(@"添加按钮点击");
    if (self.addBlock) {
         self.addBlock(sender);
    }
}

+(instancetype)shareCellWithBlock:(void(^)(UIButton* btn))addBlock{
    YMBankUnsetCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.addBlock = addBlock;
    
    return cell;
}
@end
