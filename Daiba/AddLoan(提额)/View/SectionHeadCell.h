//
//  SectionHeadCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeadCell : UITableViewCell

@property(nonatomic,copy)void(^tapBlock)(SectionHeadCell* cell);

@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

+(instancetype)shareCell;

+(instancetype)shareCellWithTapBlock:(void(^)(SectionHeadCell * cell))tapBlock;
@end
