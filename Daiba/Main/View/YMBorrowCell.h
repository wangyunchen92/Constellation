//
//  YMBorrowCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BorrowModel.h"


@interface YMBorrowCell : UITableViewCell

@property(nonatomic,strong)NSMutableArray* titlesArr;

@property(nonatomic,copy)void(^descBlock)();
@property(nonatomic,copy)void(^sureBlock)(UIButton* btn);
//借款model
@property(nonatomic,strong)BorrowModel* model;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

//底部viewHeight
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;


//确定按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

+ (instancetype)shareCell;
+(instancetype)shareCellWithBorrowModel:(BorrowModel* )model sureBlock:(void (^)(UIButton* btn))sureBlock;
@end
