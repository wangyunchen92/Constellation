//
//  YMRelationController.h
//  Daiba
//
//  Created by YouMeng on 2017/7/29.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBookModel.h"

@interface YMRelationController : BaseViewController

@property(nonatomic,assign)BOOL isShowNext;
@property(nonatomic,assign)BOOL isModify;

//刷新block
@property(nonatomic,copy)void(^refreshBlock)();
@property(nonatomic,strong)AddressBookModel* addresBookModel;

@end
