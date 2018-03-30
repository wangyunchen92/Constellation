//
//  ConsteDetailViewController.h
//  Constellation
//
//  Created by Sj03 on 2018/3/28.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "BaseViewController.h"
#import "ConsteDeatilViewModel.h"

@interface ConsteDetailViewController : BaseViewController
@property (nonatomic, strong)ConsteDeatilViewModel *viewModel;

- (instancetype)initWithViewModel:(ConsteDeatilViewModel *)viewModel;
@end
