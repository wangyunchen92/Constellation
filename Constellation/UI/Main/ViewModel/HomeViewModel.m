//
//  HomeViewModel.m
//  Constellation
//
//  Created by Sj03 on 2018/3/28.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "HomeViewModel.h"
#import "FMManage.h"
#import "ConstellationModel.h"

@interface HomeViewModel ()

@end

@implementation HomeViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _model = [[ConstellaDetailModel alloc] init];
        _serverArray = [[NSMutableArray alloc] init];
        _bannerArray = [[NSMutableArray alloc] initWithObjects:@"Banner1",@"测算页banner",@"Banner2", nil];
        _subject_isRedPacket = [[RACSubject alloc] init];
        [self initUsSigin];
    }
    return self;
}

- (void)initUsSigin {
    [self.subject_isRedPacket subscribeNext:^(id x) {
        HttpRequestMode* model = [[HttpRequestMode alloc]init];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params addUnEmptyString:@"10" forKey:@"type"];
        model.parameters = params;
        model.url = GetRedPacketList;
        model.name = @"红包";
        [[HttpClient sharedInstance]requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
            NSString *imagestr = [response.result stringForKey:@"icon"];
            NSString *url = [response.result stringForKey:@"url"];
            if (self.block_redPacket) {
                self.block_redPacket(url,imagestr);
            }
        } Failure:^(HttpRequest *request, HttpResponse *response) {
            [BasePopoverView showFailHUDToWindow:response.errorMsg];
        } RequsetStart:^{
            
        } ResponseEnd:^{
            
        }];
    }];
}

- (void)initSigin {
    self.dataArray = [[FMManage sharedInstance] findAllConstellationDetail];
    [self.subject_getDate subscribeNext:^(id x) {
        [self.serverArray removeAllObjects];
        HttpRequestMode* model = [[HttpRequestMode alloc]init];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params addUnEmptyString:[self consteTranslate:[self.model.consteID integerValue]]  forKey:@"star"];
        model.parameters = params;
        model.url = GetConsteDetail;
        model.name = @"星座内容详情";
        
        [BasePopoverView showHUDToWindow:YES withMessage:@"加载中..."];
        [[HttpClient sharedInstance]requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
            [BasePopoverView hideHUDForWindow:YES];
            ConstellaDayModel *dayModel = [[ConstellaDayModel alloc] init];
            [dayModel getDateForeServer:[response.result dictForKey:@"day"]];
            
            ConstellaDayModel *yesDayModel = [[ConstellaDayModel alloc] init];
            [yesDayModel getDateForeServer:[response.result dictForKey:@"tomorrow"]];
           
            ConstellaWeakModel *weakModel = [[ConstellaWeakModel alloc] init];
            [weakModel getDateForeServer:[response.result dictForKey:@"week"]];
            
            ConstellaMonthModel *monthModel = [[ConstellaMonthModel alloc] init];
            [monthModel getDateForeServer:[response.result dictForKey:@"month"]];
            
            ConstellaYearModel *yearModel = [[ConstellaYearModel alloc] init];
            [yearModel getDateForeServer:[response.result dictForKey:@"year"]];
            [self.serverArray addObject:dayModel];
            [self.serverArray addObject:yesDayModel];
            [self.serverArray addObject:weakModel];
            [self.serverArray addObject:monthModel];
            [self.serverArray addObject:yearModel];
            
            if (self.block_reloadDate) {
                self.block_reloadDate();
            }
        } Failure:^(HttpRequest *request, HttpResponse *response) {
            [BasePopoverView showFailHUDToWindow:response.errorMsg];
        } RequsetStart:^{
            
        } ResponseEnd:^{
            
        }];
    }];
   
}


- (NSString *)consteTranslate:(NSInteger )tag {
    NSString *str;
    switch (tag) {
        case 1:
            str = @"shuiping";
            break;
        case 2:
            str = @"shuangyu";
            break;
        case 3:
            str = @"baiyang";
            break;
        case 4:
            str = @"jinniu";
            break;
        case 5:
            str = @"shuangzi";
            break;
        case 6:
            str = @"juxie";
            break;
        case 7:
            str = @"shizi";
            break;
        case 8:
            str = @"chunv";
            break;
        case 9:
            str = @"tiancheng";
            break;
        case 10:
            str = @"tianxie";
            break;
        case 11:
            str = @"sheshou";
            break;
        case 12:
            str = @"mojie";
            break;
        default:
            break;
    }
    return str;
}

@end
