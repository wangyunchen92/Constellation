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
    }
    return self;
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
        [[HttpClient sharedInstance]requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
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
        case 0:
            str = @"shuiping";
            break;
        case 1:
            str = @"shuangyu";
            break;
        case 2:
            str = @"baiyang";
            break;
        case 3:
            str = @"jinniu";
            break;
        case 4:
            str = @"shuangzi";
            break;
        case 5:
            str = @"juxie";
            break;
        case 6:
            str = @"shizi";
            break;
        case 7:
            str = @"chunv";
            break;
        case 8:
            str = @"tiancheng";
            break;
        case 9:
            str = @"tianxie";
            break;
        case 10:
            str = @"sheshou";
            break;
        case 11:
            str = @"mojie";
            break;
        default:
            break;
    }
    return str;
}

@end
