//
//  YMBankListCollectionViewCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/29.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMBankListCollectionViewCell : UICollectionViewCell

//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


+ (instancetype)shareCell;

@end
