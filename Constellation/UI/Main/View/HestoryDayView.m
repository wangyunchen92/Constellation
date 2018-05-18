//
//  HestoryDayView.m
//  Constellation
//
//  Created by Sj03 on 2018/4/8.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "HestoryDayView.h"
@interface HestoryDayView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *contentLabels;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong)NSArray *dataArray;


@end

@implementation HestoryDayView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HestoryDayView class]) owner:self options:nil]lastObject];
        self.view.frame = self.bounds;
        [self addSubview:self.view];
        NSDate *date = [NSDate date];
         NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
         [forMatter setDateFormat:@"MM月dd日"];
        NSString *dateStr = [forMatter stringFromDate:date];
        self.dateLabel.text = dateStr;
        [self getDateForServer];
    }
    return self;
}

- (void)getDateForServer {
    HttpRequestMode* model = [[HttpRequestMode alloc]init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    model.parameters = params;
    model.url = GetHistoryList;
    model.name = @"历史上的今天";
    [[HttpClient sharedInstance]requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
        NSArray *result = [response.result arrayForKey:@"object"];
        [self.nameLabels enumerateObjectsUsingBlock:^(UILabel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (result.count >= idx) {
                NSDictionary *dic = result[idx];
                obj.text = dic[@"year"];
            }
        }];
        
        [self.contentLabels enumerateObjectsUsingBlock:^(UILabel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (result.count >= idx) {
                NSDictionary *dic = result[idx];
                obj.text = dic[@"title"];
            }
        }];
        self.dataArray = result;
        
    } Failure:^(HttpRequest *request, HttpResponse *response) {
        [BasePopoverView showFailHUDToWindow:response.errorMsg];
    } RequsetStart:^{
        
    } ResponseEnd:^{
        
    }];
}
- (IBAction)firstAction:(UITapGestureRecognizer *)sender {
    UILabel *label = self.contentLabels[0];
    
    if (self.block_viewClick) {
        self.block_viewClick(label.text);
    }
}
- (IBAction)secendAction:(id)sender {
        UILabel *label = self.contentLabels[2];
    if (self.block_viewClick) {
        self.block_viewClick(label.text);
    }
}
- (IBAction)threeAction:(id)sender {
        UILabel *label = self.contentLabels[2];
    if (self.block_viewClick) {
        self.block_viewClick(label.text);
    }
}
- (IBAction)fourAction:(id)sender {
        UILabel *label = self.contentLabels[3];
    if (self.block_viewClick) {
        self.block_viewClick(label.text);
    }
}
- (IBAction)fiveAction:(id)sender {
        UILabel *label = self.contentLabels[4];
    if (self.block_viewClick) {
        self.block_viewClick(label.text);
    }
}
- (IBAction)moreAction:(id)sender {
    if (self.block_more) {
        self.block_more(self.dataArray);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
