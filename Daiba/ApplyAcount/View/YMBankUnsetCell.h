//
//  YMBankUnsetCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/11.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMBankUnsetCell : UITableViewCell

@property(nonatomic,copy)void(^addBlock)(UIButton* btn);

@property (weak, nonatomic) IBOutlet UIButton *addBtn;


//创建
+(instancetype)shareCellWithBlock:(void(^)(UIButton* btn))addBlock;

@end
