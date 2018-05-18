//
//  HongbaoViewController.m
//  Constellation
//
//  Created by Sj03 on 2018/5/16.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "HongbaoViewController.h"
#import <WebKit/WebKit.h>

@interface HongbaoViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong)WKWebView *webView;

@end

@implementation HongbaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavWithTitle:@"红包" leftImage:@"Whiteback" rightImage:@""];
    
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.theSimpleNavigationBar.bottomLineView.hidden = YES;
    self.theSimpleNavigationBar.backgroundColor =UIColorFromRGB(0x5d2ebe);
    
    self.webView = [[WKWebView alloc] init];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(64);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        
    }];
    
    [RACObserve(self, url) subscribeNext:^(id x) {
        [BasePopoverView showHUDAddedTo:self.view animated:YES withMessage:@"加载中..."];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
        [self.webView loadRequest:request];
    }];
    // Do any additional setup after loading the view from its nib.
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [BasePopoverView hideHUDForView:self.view animated:YES];
}

- (void)navBarButtonAction:(UIButton *)sender {
    if (sender.tag == NBButtonLeft) {
        if (self.webView.canGoBack) {
            [self.webView goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
