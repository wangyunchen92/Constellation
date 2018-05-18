//
//  CommandTool.m
//  daikuanchaoshi
//
//  Created by Sj03 on 2018/1/2.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "CommandTool.h"
#import "YMUpdateView.h"

@interface CommandTool ()


@end

@implementation CommandTool

- (instancetype)init {
    self = [super init];
    if (self) {
      
        [self initCommand];
    }
    return self;
}

- (void)initCommand {

    self.command_haveNewVersion = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            HttpRequestMode *model = [[HttpRequestMode alloc]init];
            model.name= @"获取更新信息";
            model.url = GetApkUpdate;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params addUnEmptyString:@"default_channel" forKey:@"channel_key"];
            [params addUnEmptyString:@"com.ymnet.constellation" forKey:@"package_name"];
            model.parameters = params;
            [[HttpClient sharedInstance]requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
                [BasePopoverView hideHUDForWindow:YES];
                YMUpdateView *updateView = [[YMUpdateView alloc] initWithTitle:[NSString stringWithFormat:@"%@", [response.result objectForKey:@"title"]] imgStr:nil message:[NSString stringWithFormat:@"%@", [response.result objectForKey:@"description"]] sureBtn:@"立即更新" cancleBtn:@"取消"];
                updateView.resultIndex = ^(NSInteger index){
                    if (index == 1) {
                        [subscriber sendNext:@YES];
                        [subscriber sendCompleted];
                    } else {
                        NSURL *url = [NSURL URLWithString:[response.result objectForKey:@"url"]];
                        dispatch_main_async(^{
                            [[UIApplication sharedApplication] openURL:url];
                        });
                    }
                };
                [updateView showXLAlertView];
            } Failure:^(HttpRequest *request, HttpResponse *response) {
                [subscriber sendError:nil];
                
            } RequsetStart:^{
                
            } ResponseEnd:^{
                
            }];
            
            return nil;
        }];
    }];
    
    
    self.command_isTest = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            HttpRequestMode *model = [[HttpRequestMode alloc]init];
            model.name= @"是否为测试";
            model.url = GetIsTest;
            [[HttpClient sharedInstance]requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
                [BasePopoverView hideHUDForWindow:YES];
                NSInteger tag  = [response.result integerForKey:@"object"];
                if (tag == 0) {
                    [UserDefaultsTool setBool:NO withKey:isTest];
                } else {
                    [UserDefaultsTool setBool:YES withKey:isFirstLogin];
                }
                [subscriber sendNext:@YES];
                [subscriber sendCompleted];
                
            } Failure:^(HttpRequest *request, HttpResponse *response) {
                [subscriber sendError:nil];
                
            } RequsetStart:^{
                
            } ResponseEnd:^{
                
            }];
            
            return nil;
        }];
    }];
    
    
    self.command_channel = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [UserDefaultsTool setBool:NO withKey:isRedPacketTest];
            [UserDefaultsTool setBool:NO withKey:isMainBanner];
            HttpRequestMode *model = [[HttpRequestMode alloc]init];
            model.name= @"开关接口";
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params addUnEmptyString:@"dev_test" forKey:@"channel_key"];
            [params addUnEmptyString:@"ys" forKey:@"show_key"];
            model.url = GetChannel;
            model.parameters = params;
            [[HttpClient sharedInstance]requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
                [BasePopoverView hideHUDForWindow:YES];
                NSInteger readtest = [response.result integerForKey:@"red_packet"];
                if (readtest == 1) {
                    [UserDefaultsTool setBool:YES withKey:isRedPacketTest];
                } else {
                    [UserDefaultsTool setBool:NO withKey:isRedPacketTest];
                }
                
                NSInteger mainBanner = [response.result integerForKey:@"home_banner"];
                if (mainBanner == 1) {
                    [UserDefaultsTool setBool:YES withKey:isMainBanner];
                } else {
                    [UserDefaultsTool setBool:NO withKey:isMainBanner];
                }

                [subscriber sendNext:@YES];
                [subscriber sendCompleted];
                
            } Failure:^(HttpRequest *request, HttpResponse *response) {
                [subscriber sendError:nil];
                
            } RequsetStart:^{
                
            } ResponseEnd:^{
                
            }];
            
            return nil;
        }];
    }];
    
    
 
    
}
@end
