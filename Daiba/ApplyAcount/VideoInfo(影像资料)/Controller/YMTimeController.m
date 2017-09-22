//
//  YMTimeController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTimeController.h"

@interface YMTimeController ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property(nonatomic,strong)NSTimer* timer;
@property(nonatomic,assign)int count;
@end

@implementation YMTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 3;
    _countLabel.font = Font(SCREEN_WIDTH * 0.56) ;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(indexDecrease ) userInfo:nil repeats:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}
-(void)indexDecrease{
     _count --;
    _countLabel.text = [NSString stringWithFormat:@"%d",_count];
    _tipLabel.text = [NSString stringWithFormat:@"请在%d秒后，开始朗读...",_count];
    if (_count == 0) {
        if (self.startRecordBlock) {
            self.startRecordBlock(YES);
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


@end
