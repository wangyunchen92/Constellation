//
//  YMMsgCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMsgCell.h"

@interface YMMsgCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation YMMsgCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(YMMsgModel *)model{
    _model = model;
    _titlLabel.text = @"系统消息";
    _msgLabel.text  = model.content;
    _timeLabel.text = model.add_time;
    //未读 1 已读 0
    if (model.status.integerValue == 0) {
        _titlLabel.textColor = HEX(@"999999");
    }else{
        _titlLabel.textColor = HEX(@"333333");
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *view in control.subviews)
            {
                if ([view isKindOfClass: [UIImageView class]]) {
                    UIImageView *image=(UIImageView *)view;
                    if (self.selected) {
                        image.image=[UIImage imageNamed:@"CellButtonSelected"];
                    }
                    else
                    {
                        image.image=[UIImage imageNamed:@"CellButton"];
                    }
                }
            }
        }
    }
    
    [super layoutSubviews];
}

//当你长按一个按钮时看到的还是系统的蓝色圆圈，还要改变长按编辑的代码
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *view in control.subviews)
            {
                if ([view isKindOfClass: [UIImageView class]]) {
                    UIImageView *image=(UIImageView *)view;
                    if (!self.selected) {
                        image.image=[UIImage imageNamed:@"CellButton"];
                    }
                }
            }
        }
    }
}
+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView{
    YMMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
    }
    return cell;
}

@end
