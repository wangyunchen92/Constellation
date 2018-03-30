//
//  ConsteDetailViewController.m
//  Constellation
//
//  Created by Sj03 on 2018/3/28.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "ConsteDetailViewController.h"

@interface ConsteDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *xztdLabel;
@property (weak, nonatomic) IBOutlet UILabel *sxsxLabel;
@property (weak, nonatomic) IBOutlet UILabel *zggwLabel;
@property (weak, nonatomic) IBOutlet UILabel *yysxLabel;
@property (weak, nonatomic) IBOutlet UILabel *zdtzLabel;
@property (weak, nonatomic) IBOutlet UILabel *zgxxLabel;
@property (weak, nonatomic) IBOutlet UILabel *xyysLabel;
@property (weak, nonatomic) IBOutlet UILabel *jxswLabel;
@property (weak, nonatomic) IBOutlet UILabel *xyhmLabel;
@property (weak, nonatomic) IBOutlet UILabel *kyjsLabel;
@property (weak, nonatomic) IBOutlet UILabel *jbtzLabel;
@property (weak, nonatomic) IBOutlet UILabel *jttzLabel;
@property (weak, nonatomic) IBOutlet UILabel *xsfgLabel;
@property (weak, nonatomic) IBOutlet UILabel *gxmdLabel;
@property (weak, nonatomic) IBOutlet UILabel *summerLabel;

@end

@implementation ConsteDetailViewController
- (instancetype)initWithViewModel:(ConsteDeatilViewModel *)viewModel {
    
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadUIData {
    [self createNavWithTitle:@"" leftImage:@"Whiteback" rightText:@""];
    self.theSimpleNavigationBar.bottomLineView.backgroundColor = [UIColor clearColor];
    self.theSimpleNavigationBar.backgroundColor = UIColorFromRGB(0x5d2ebe);
    [self.theSimpleNavigationBar.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)initData {
    self.imageView.image = IMAGE_NAME([ToolUtil imagetrans:[self.viewModel.model.consteID integerValue]]);
    self.nameLabel.text = self.viewModel.model.consteName;
    self.dateLabel.text = self.viewModel.model.consteDate;
    self.xztdLabel.text = self.viewModel.model.consteSpec;
    self.sxsxLabel.text = self.viewModel.model.consteSxsx;
    self.zggwLabel.text = self.viewModel.model.consteGW;
    self.yysxLabel.text = self.viewModel.model.consteYysx;
    self.zdtzLabel.text = self.viewModel.model.consteTz;
    self.zgxxLabel.text = self.viewModel.model.consteZgxx;
    self.xyysLabel.text = self.viewModel.model.consteXyys;
    self.jxswLabel.text = self.viewModel.model.consteJxsw;
    self.xyhmLabel.text = self.viewModel.model.consteXyHm;
    self.kyjsLabel.text= self.viewModel.model.consteKyjs;
    self.jbtzLabel.text = self.viewModel.model.consteAdvantage;
    self.jttzLabel.text = self.viewModel.model.consteJttz;
    self.xsfgLabel.text = self.viewModel.model.consteXsfg;
    self.gxmdLabel.text = self.viewModel.model.consteGxmd;
    self.summerLabel.text = self.viewModel.model.consteSummary;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
    if (offY < 0) {
        scrollView.contentOffset = CGPointZero;
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
