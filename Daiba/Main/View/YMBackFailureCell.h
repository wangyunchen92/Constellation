//
//  YMBackFailureCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/8.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "BorrowModel.h"


@interface YMBackFailureCell : UITableViewCell

@property(nonatomic,copy)void(^refreshBlock)(UIButton* btn);


+(instancetype)shareCellWithStutus:(int)status refreshBlock:(void(^)(UIButton* btn))refreshBlock;

+(instancetype)shareCellWithUsrModel:(UserModel*)usrModel borrowModel:(BorrowModel* )borrowModel refreshBlock:(void(^)(UIButton* btn))refreshBlock;


@end
