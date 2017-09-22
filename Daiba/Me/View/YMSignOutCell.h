//
//  YMSignOutCell.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/10.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMSignOutCell : UITableViewCell

@property(nonatomic,copy)void(^signOutBlock)(UIButton* signOutBtn);
//退出登陆
@property (weak, nonatomic) IBOutlet UIButton *signOutBtn;


+(instancetype)cellDequeueReusableCellWithTableView:(UITableView* )tableView;
@end
