//
//  RelationCell.h
//  Daiba
//
//  Created by YouMeng on 2017/7/29.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookModel.h"

@interface RelationCell : UITableViewCell

//修改block
@property(nonatomic,copy)void(^modifyBlock)(UIButton* btn);

@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
//姓名
@property (weak, nonatomic) IBOutlet UITextField *nameTextFd;
//电话
@property (weak, nonatomic) IBOutlet UITextField *numTextFd;

//修改btn
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

//电话簿 模型
@property(nonatomic,strong)AddressBookModel* addrsBookModel;


+(instancetype)shareCellWithTitle:(NSString* )tilte modifyBlock:(void (^)(UIButton* btn))modifyBlock;

@end
