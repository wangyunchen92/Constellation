//
//  YMTitleCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/2/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMTitleCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
//详情label
@property (weak, nonatomic) IBOutlet UILabel *detaiLabel;

//创建实例
+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;

-(void)cellWithTitle:(NSString* )title icon:(NSString* )iconStr;
@end
