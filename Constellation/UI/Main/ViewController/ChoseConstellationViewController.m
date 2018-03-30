//
//  ChoseConstellationViewController.m
//  Constellation
//
//  Created by Sj03 on 2018/3/28.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "ChoseConstellationViewController.h"
#import "XWPresentOneTransition.h"

@interface ChoseConstellationViewController ()<UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskTopConstraint;


@end

@implementation ChoseConstellationViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        //为什么要设置为Custom，在最后说明.
        self.modalPresentationStyle = UIModalPresentationCustom;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    if (iPhone5) {
        self.maskTopConstraint.constant = 30;
    } else if(iPhone6Plus) {
        self.maskTopConstraint.constant = 70;
    }
    // Do any additional setup after loading the view from its nib.
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    //这里我们初始化presentType
    return [XWPresentOneTransition transitionWithTransitionType:XWPresentOneTransitionTypePresent];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    return [XWPresentOneTransition transitionWithTransitionType:XWPresentOneTransitionTypeDismiss];
}

- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (IBAction)otherAction:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)seleAction:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    if (self.block_sele) {
        self.block_sele(view.tag);
    }
    [self dismissViewControllerAnimated:NO completion:^{
    }];
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
