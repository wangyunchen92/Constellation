//
//  MainSetViewController.m
//  Constellation
//
//  Created by Sj03 on 2018/5/16.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "MainSetViewController.h"
#import "AboutUsViewController.h"

@interface MainSetViewController ()

@end

@implementation MainSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavWithTitle:@"设置" leftImage:@"Whiteback" rightImage:@""];
    
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.theSimpleNavigationBar.bottomLineView.hidden = YES;
    self.theSimpleNavigationBar.backgroundColor =UIColorFromRGB(0x5d2ebe);
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)aboutUsAction:(id)sender {
    AboutUsViewController *AVC = [[AboutUsViewController alloc] init];
    [self.navigationController pushViewController:AVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
