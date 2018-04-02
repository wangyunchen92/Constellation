//
//  HomeBoardViewController.m
//  Constellation
//
//  Created by Sj03 on 2018/3/29.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "HomeBoardViewController.h"
#import "HomeBoardIteamViewController.h"

@interface HomeBoardViewController ()
@property (nonatomic, strong)NSMutableArray *titleArray;
@property (nonatomic, assign)NSInteger type;

@end

@implementation HomeBoardViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleArray = [[NSMutableArray alloc] initWithObjects:@"今日",@"明日",@"本周",@"本月",@"年运", nil];
    }
    self.type = 1;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

// 顶部有几个Icon
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 5;
}

// 顶部Icon的Title
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return  self.titleArray[index];
}

// 每个Icon 对应产生的View
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    HomeBoardIteamViewController *VC = [[HomeBoardIteamViewController alloc] init];
    if (self.dataArray.count == 5) {
        VC.model =  [self.dataArray objectAtIndex:index];
    }
    if (index == 2) {
        VC.type = 1;
    } else if (index == 3) {
        VC.type = 2;
    } else if (index == 4) {
        VC.type = 3;
    }
    return VC;
}

- (void)pageController:(WMPageController *)pageController showViewController:(__kindof HomeBoardIteamViewController *)viewController withInfo:(NSDictionary *)info {
    
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        self.reloadHeight = viewController.reloadHeight+ 44;
    }];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
//    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    CGFloat width = kScreenWidth/5;
    return width;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    //    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, 0, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
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
