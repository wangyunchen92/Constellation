//
//  YMMsgDetailCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMsgDetailCell.h"

@interface YMMsgDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end


@implementation YMMsgDetailCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
-(void)setModel:(YMMsgModel *)model{
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"newsPaceholder"]];
    _titlLabel.text = @"系统消息";
    _timeLabel.text = model.add_time;
    _msgLabel.text = model.content;
    //@"哈哈减肥啦啊发酵；发 啦放假啦发几个拉萨了张家口 v 拉萨布局啊邻居啊世界杯 v 了就啦赶紧送表格啦就是个垃圾股 i 哦啦就是光荣 i 诶基本 v了竟然公然举办借款人规律就是大肉包裤薄但是人家奔跑疾病";
    

}
@end
