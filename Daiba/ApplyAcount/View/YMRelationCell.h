//
//  YMRelationCell.h
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookModel.h"

@interface YMRelationCell : UITableViewCell

@property(nonatomic,copy)void(^modifyBlock)(UIButton* btn);

@property (weak, nonatomic) IBOutlet UILabel *familyLabel;

@property (weak, nonatomic) IBOutlet UILabel *friendLabel;

@property (weak, nonatomic) IBOutlet UILabel *workmateLabel;

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@property(nonatomic,strong)AddressBookModel* addresBookModel;

+(instancetype)shareCellWithModifyBlock:(void (^)(UIButton* btn))modifyBlock;
@end
