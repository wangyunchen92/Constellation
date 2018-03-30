//
//  FMManage.m
//  Constellation
//
//  Created by Sj03 on 2018/3/28.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "FMManage.h"
#import <FMDB.h>
#import "ConstellaDetailModel.h"

@interface FMManage ()
@property (nonatomic, strong)FMDatabase *db;
@end

@implementation FMManage
static FMManage *manage = nil;

+ (FMManage *)sharedInstance {
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        if(manage == nil) {
            manage = [[FMManage alloc]init];
        }
    });
    [manage openDB];
    return manage;
}

- (void)openDB {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"constellation.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileName]) {
        // 获得数据库文件在工程中的路径——源路径。
        NSString *sourcesPath = [[NSBundle mainBundle] pathForResource:@"constellation"ofType:@"db"];
        NSError *error ;
        if ([fileManager copyItemAtPath:sourcesPath toPath:fileName error:&error]) {
            NSLog(@"数据库移动成功");
        } else {
            NSLog(@"数据库移动失败");
        }
    }
    // 2.获得数据库
    self.db = [FMDatabase databaseWithPath:fileName];
    
    if (![self.db open]) {
        NSLog(@"打开数据库失败");
    }

}

- (NSMutableArray *)findAllConstellationDetail {
    
    FMResultSet *result = [self.db executeQuery:@"SELECT * FROM detail"];
    NSMutableArray *nsmArray = [[NSMutableArray alloc] init];
    while ([result next]) {
        ConstellaDetailModel *model = [[ConstellaDetailModel alloc] init];
        [model getModelForSqlit:result];
        [nsmArray addObject:model];
    }
    
    [self.db close];
    return nsmArray;
}
@end
