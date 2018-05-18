//
//  HestoryDayView.h
//  Constellation
//
//  Created by Sj03 on 2018/4/8.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HestoryDayView : UIView
@property (nonatomic, copy)void (^block_viewClick)(NSString *title);
@property (nonatomic, copy)void (^block_more)(NSArray *array);

@end
