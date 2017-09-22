//
//  ShareButton.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/14.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareButton : UIButton

@property(strong,nonatomic)UIImageView *imagView;

@property(strong,nonatomic)UILabel *titlLabel;

- (instancetype)initWithFrame:(CGRect)frame imgStr:(NSString* )imgStr title:(NSString* )title;
@end
