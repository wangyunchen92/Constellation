//
//  YMCreditCollectionCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMCreditCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


+ (instancetype)shareCell;

@end
