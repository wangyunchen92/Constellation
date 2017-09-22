//
//  BaseViewController.m
//  CloudPush
//
//  Created by APPLE on 17/2/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseViewController.h"
#import "YMNavigationController.h"
#import "YMLoginController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackGroundColor;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //推出键盘
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//添加手势
- (void)addTapGestureOnView:(UIView*)view target:(id)target selector:(SEL)selector{
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    gest.numberOfTapsRequired = 1;
    gest.numberOfTouchesRequired = 1;
    gest.delegate = self;
    [view addGestureRecognizer:gest];
}
//登陆提醒
-(void)showUserLoginAlerView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您还没有登陆?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YMLoginController *lvc = [[YMLoginController alloc] init];
        YMNavigationController *naVc = [[YMNavigationController alloc] initWithRootViewController:lvc];
        [self presentViewController:naVc animated:YES completion:nil];
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
