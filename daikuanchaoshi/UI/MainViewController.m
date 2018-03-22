//
//  MainViewController.m
//  ZrtTool
//
//  Created by BillyWang on 15/10/14.
//  Copyright © 2015年 zrt. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "BackgroundViewController.h"

@interface MainViewController()<UITabBarControllerDelegate>

@end

@implementation MainViewController

#pragma mark -

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self constructNotLoginViewControllers];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.selectedViewController endAppearanceTransition];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = (UINavigationController *)viewController;
    
    if ([tabBarController.viewControllers containsObject:nav]) {
//        UIViewController *vc = [nav.viewControllers objectAtIndex:0];
//        
//        if ([vc respondsToSelector:@selector(refreshDefaultData)]) {
//            [vc performSelector:@selector(refreshDefaultData)];
//        }
    }
    
    return YES;
}

#pragma mark - 手势密码验证

- (void)createViewControllers
{
//    FamilyViewController *hvc    = [[FamilyViewController alloc] init];
    BaseViewController *hvc      = [[BaseViewController alloc] init];
    BaseViewController *mvc = [[BaseViewController alloc] init];
    BaseViewController *cvc    = [[BaseViewController alloc]init];
    BaseViewController *minevc   = [[BaseViewController alloc]init];
    
    UINavigationController *hNav    = [[UINavigationController alloc] initWithRootViewController:hvc];
    UINavigationController *mNav    = [[UINavigationController alloc] initWithRootViewController:mvc];
    UINavigationController *cNav    = [[UINavigationController alloc] initWithRootViewController:cvc];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:minevc];
    
    [self setTabBarItem:hNav
                  title:@"首页"
            selectImage:@"多彩b"
          unselectImage:@"多彩"
                    tag:1];
    
    [self setTabBarItem:mNav
                  title:@"基金组合"
            selectImage:@"投资管家-选中"
          unselectImage:@"投资管家"
                    tag:2];
    
    [self setTabBarItem:cNav
                  title:@"投资圈"
            selectImage:@"财富圈-选中"
          unselectImage:@"财富圈"
                    tag:3];
    
    [self setTabBarItem:mineNav
                  title:@"我的"
            selectImage:@"我的－选中"
          unselectImage:@"我的"
                    tag:4];
    
    self.viewControllers = @[hNav,mNav, cNav, mineNav];
}

- (void)constructNotLoginViewControllers
{
    [self createViewControllers];
    
    self.selectedIndex = 0;
//    self.tabBar.backgroundImage = [UIImage imageWithColor:RGB(237, 217, 219)];
    self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
}

- (void)setTabBarItem:(UINavigationController *) navController
                title:(NSString *)title
          selectImage:(NSString *)selectImage
        unselectImage:(NSString *)unselectImage
                  tag:(NSUInteger)tag
{
    UIImage * normalSelectImage = [IMAGE_NAME(selectImage) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * normalImage = [IMAGE_NAME(unselectImage) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navController.tabBarItem.title = title;
    
    NSDictionary *normalDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               UIColorFromRGB(0x004486),
                               NSForegroundColorAttributeName, nil];
    [navController.tabBarItem setTitleTextAttributes:normalDic forState:UIControlStateSelected];
    navController.tabBarItem.image = normalImage;
    navController.tabBarItem.selectedImage = normalSelectImage;
}




- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

    LoginViewController *loginVC = [[LoginViewController alloc]init];

    //                self.window.rootViewController = loginVC;
    // 弹出界面必须含有容器,否则不能点击进入下一级界面
    [[BackgroundViewController share] showLoginViewController:loginVC animated:NO completion:^{
        
    }];
    
}



@end