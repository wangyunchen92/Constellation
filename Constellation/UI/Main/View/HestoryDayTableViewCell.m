//
//  HestoryDayTableViewCell.m
//  Constellation
//
//  Created by Sj03 on 2018/4/8.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "HestoryDayTableViewCell.h"
@interface HestoryDayTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HestoryDayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)getDateForServer:(NSDictionary *)dic {
    self.nameLabel.text = [NSString stringWithFormat:@"%@年",[dic stringForKey:@"year"]];
    self.contentLabel.text = [dic stringForKey:@"title"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
