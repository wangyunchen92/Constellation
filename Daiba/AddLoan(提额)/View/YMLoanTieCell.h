//
//  YMLoanTieCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/22.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCreditModel.h"


@interface YMLoanTieCell : UITableViewCell

// icon
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
// 标题
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

//详情imgView
@property (weak, nonatomic) IBOutlet UIImageView *detailImgView;


//状态按钮 右间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusRightMargin;


+(instancetype)shareCellWithTableView:(UITableView* )tableView;

//-(void)cellWithStatus:(NSString* )status;


-(void)cellWithStatus:(NSString* )status indexPath:(NSIndexPath* )indexPath;

-(void)cellWithCreditModel:(YMCreditModel* )model indexPath:(NSIndexPath* )indexPath;
@end
