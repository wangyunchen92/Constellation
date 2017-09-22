//
//  YMCollectionViewCell.h
//  Daiba
//
//  Created by YouMeng on 2017/8/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXTProgressLabel.h"


@interface YMCollectionViewCell : UICollectionViewCell

//显示文字
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//显示进度的文字
@property (strong, nonatomic) JXTProgressLabel *titleLabel;


//+(instancetype)shareCell;
//
//-(instancetype)initWithFrame:(CGRect)frame text:(NSString* )text;

-(instancetype)initWithFrame:(CGRect)frame;
@end
