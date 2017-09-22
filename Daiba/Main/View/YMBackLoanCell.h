//
//  YMBackLoanCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorrowModel.h"


@interface YMBackLoanCell : UITableViewCell

@property(nonatomic,strong)BorrowModel* borrowModel;

@property(nonatomic,copy)void(^sumBlock)(UIButton* sumBtn);

@property(nonatomic,copy)void(^backBlock)(UIButton* btn);

+(instancetype)shareCellWithBorrowModel:(BorrowModel* )borrowModel backBlock:(void(^)(UIButton* btn))backBlock;
@end
