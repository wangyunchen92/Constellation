//
//  HaveStartView.h
//  Constellation
//
//  Created by Sj03 on 2018/3/30.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConstellationModel;

@interface HaveStartView : UIView
@property (nonatomic, assign)CGFloat reloadHeight;
@property (nonatomic, assign)NSInteger type;
- (void)getDateForeModel:(ConstellationModel *)model;
@end
