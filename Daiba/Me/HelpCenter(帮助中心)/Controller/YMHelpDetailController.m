//
//  YMHelpDetailController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/9.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMHelpDetailController.h"

@interface YMHelpDetailController ()

@property (weak, nonatomic) IBOutlet UILabel *titlLabel;
@property (weak, nonatomic) IBOutlet UILabel *detalLabel;

//lineView
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation YMHelpDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"问题详情";
    
    self.titlLabel.text = self.model.title;
    
    [self requstContentData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)requstContentData {
    
    [[HttpManger sharedInstance]callHTTPReqAPI:HelpInfoURL params:@{@"id" : self.typeId} view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
         self.detalLabel.text = [NSString stringWithFormat:@"\n%@",responseObject[@"data"][@"content"]];
        
    }];
    
    if (self.detalLabel.text.length == 0) {
        self.lineView.hidden = YES;
    }
}
@end
