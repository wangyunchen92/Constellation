//
//  YMAboutController.m
//  Daiba
//
//  Created by YouMeng on 2017/8/9.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMAboutController.h"
#import "YMLogoCell.h"
#import "YMHeightTools.h"
#import "SectionHeadCell.h"


@interface YMAboutController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray* dataArr;


@property(nonatomic,strong)YMLogoCell* logoCell;
@end

@implementation YMAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoCell = [YMLogoCell shareCell];
    
    NSString* introStr = @"贷吧是利欧控股集团（股票代码：002131） - 温岭市利欧小额贷款有限公司国内创新的对接个人与权威金融机构的信贷技术服务平台，非P2P，只贷不储平台上提供各大持牌金融机构的消费金融产品，提供小额消费信贷服务，为用户消费量身打造金融服务。";
    self.logoCell.introLabel.text = introStr;
    
    self.logoCell.height = [YMHeightTools heightForText:introStr fontSize:14 width:SCREEN_WIDTH - 15 * 2] + 150;
    
    self.tableView.tableHeaderView =  self.logoCell ;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"版本信息",@"官方网站",@"官方微信"].mutableCopy;
    }
    return _dataArr;
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SectionHeadCell* cell = [SectionHeadCell shareCell];
  
    cell.detailLabel.text = @"";
    
    if (indexPath.row == 0) {
         cell.titlLabel.text = [NSString stringWithFormat:@"%@：V%@",_dataArr[indexPath.row],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    }
    if (indexPath.row == 1) {
         cell.titlLabel.text = [NSString stringWithFormat:@"%@：%@",_dataArr[indexPath.row],@"https://www.hjr.com"];
        [YMTool labelColorWithLabel:cell.titlLabel font:Font(14) range:NSMakeRange(5, cell.titlLabel.text.length - 5) color:BlueBtnColor];
    }
    if (indexPath.row == 2) {
         cell.titlLabel.text = [NSString stringWithFormat:@"%@：%@",_dataArr[indexPath.row],@"万圣小贷吧"];
    }

    if (indexPath.row == self.dataArr.count - 1) {
        //去掉分割线
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
    }
    cell.titlLabel.font = Font(14);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end
