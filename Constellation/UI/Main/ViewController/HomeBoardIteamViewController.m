//
//  HomeBoardIteamViewController.m
//  Constellation
//
//  Created by Sj03 on 2018/3/29.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "HomeBoardIteamViewController.h"
#import "HaveStartView.h"

@interface HomeBoardIteamViewController ()
@property (weak, nonatomic) IBOutlet HaveStartView *boardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boardViewHeightConstraint;


@end

@implementation HomeBoardIteamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.ztyxLabel.hidden = YES;
    self.boardView.type = self.type;
    [self.boardView getDateForeModel:nil];
    self.reloadHeight = self.boardView.reloadHeight;

    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {

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
