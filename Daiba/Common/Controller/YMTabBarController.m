//
//  YMTabBarController.m
//  CalendarEveryday
//
//  Created by YouMeng on 2017/7/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMTabBarController.h"
#import "UIImage+Extension.h"

#import "YMMeController.h"
#import "YMWaitController.h"
#import "YMMainController.h"
#import "YMAddLoanController.h"



@interface YMTabBarController ()

@end

@implementation YMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.tabBar.tintColor = TabBarTintColor;
    // 添加所有的子控制器
    [self addChildVCs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/**
 *  添加所有的子控制器
 */
- (void)addChildVCs{
    //贷款
    [self setUpChildViewController:[[YMMainController alloc]init] title:@"贷款" imageNamed:@"贷款"];
    //提额
    [self setUpChildViewController:[[YMAddLoanController alloc]init] title:@"提额" imageNamed:@"提额"];
    //免息
    [self setUpChildViewController:[[YMWaitController alloc]init] title:@"免息" imageNamed:@"免息"];
    //我的
    [self setUpChildViewController:[[YMMeController alloc]init] title:@"我的" imageNamed:@"我的"];
  
}

//创建子控制的方法
-(void)setUpChildViewController:(UIViewController *)vc title:(NSString *)title imageNamed:(NSString *)imageName{
    //精华
    YMNavigationController * naVc = [[YMNavigationController alloc]initWithRootViewController:vc];
    vc.title = title;//相当于上面两句
    if ([title isEqualToString:@"我的"] || [title isEqualToString:@"贷款"]) {
        vc.title = @"";
        vc.tabBarItem.title = title;
    }

    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    NSString * selectImageName = [imageName stringByAppendingString:@"选中"];
    vc.tabBarItem.selectedImage = [UIImage originarImageNamed:selectImageName];
    //给TabBarController 添加子控制器
    [self addChildViewController:naVc];
}



@end
