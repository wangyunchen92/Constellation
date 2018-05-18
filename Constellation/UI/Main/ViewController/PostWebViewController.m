//
//  PostWebViewController.m
//  daikuanchaoshi
//
//  Created by Sj03 on 2018/3/5.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "PostWebViewController.h"
#import "YMWebProgressLayer.h"


@interface PostWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong)YMWebProgressLayer *progressLayer; ///< 网页加载进度条
@property(nonatomic,strong)MBProgressHUD* hub;
@end

@implementation PostWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavWithTitle:self.titleStr leftImage:@"Whiteback" rightImage:nil superView:nil];
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.theSimpleNavigationBar.bottomLineView.hidden = YES;
    self.theSimpleNavigationBar.backgroundColor =UIColorFromRGB(0x5d2ebe);
    
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    self.webView.scalesPageToFit = YES;
    //请求ulr
     @weakify(self);
    [RACObserve(self, urlStr) subscribeNext:^(id x) {
        @strongify(self);
        [self requestURL];
    }];

}

-(void)requestURL{
    NSString *string = [NSString stringWithFormat:@"https://yz.m.sm.cn/s?from=ios&q=%@",[self.titleStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:string]];
    [self.webView loadRequest:request];
}
// navBar 回调
- (void)navBarButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(YMWebProgressLayer *)progressLayer{
    if (!_progressLayer) {
        _progressLayer = [YMWebProgressLayer new];
        _progressLayer.frame = CGRectMake(0, 62, kScreenWidth, 2);
        _progressLayer.hidden = NO;
        [self.theSimpleNavigationBar.layer addSublayer:_progressLayer];
        // [self.navigationController.navigationBar.layer addSublayer:_progressLayer];
    }
    _progressLayer.hidden = NO;
    return _progressLayer;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.webView removeFromSuperview];
    self.webView = nil;
}

- (void)dealloc {
    [self.progressLayer closeTimer];
    [self.progressLayer removeFromSuperlayer];
    self.progressLayer = nil;
    self.webView = nil;
    NSLog(@"i am dealloc");
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"开始加载数据 request == %@",request);
    [self.progressLayer startLoad];

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //self.hub = [MBProgressHUD showMessag:@"加载中..." toView:self.view];
    [self.progressLayer startLoad];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //[self.hub removeFromSuperview];
    [self.progressLayer finishedLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.hub removeFromSuperview];
    [self.progressLayer finishedLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
