//
//  YMTitleCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTitleCell.h"


@implementation YMTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

//创建实例
+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView{
    YMTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    }
    return cell;
}
-(void)cellWithTitle:(NSString* )title icon:(NSString* )iconStr {

    _imgView.image = [UIImage imageNamed:iconStr];
    _titlLabel.text = title;
    
   // CGRect newRect = [_titlLabel convertRect:_titlLabel.bounds toView:self.contentView];
    
   // DDLog(@"newRect  width  == %f  x === %f y == %f",newRect.size.width,newRect.origin.x,newRect.origin.y);
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
@end
