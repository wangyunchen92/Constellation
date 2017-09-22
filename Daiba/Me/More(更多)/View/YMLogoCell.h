//
//  YMLogoCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/9.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMLogoCell : UITableViewCell

//详细介绍
@property (weak, nonatomic) IBOutlet UILabel *introLabel;


+(instancetype)shareCell;

@end
