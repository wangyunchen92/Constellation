//
//  YMDataManager.m
//  Daiba
//
//  Created by YouMeng on 2017/8/2.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMDataManager.h"
#import "YMCityModel.h"


@implementation YMDataManager
/*
 单实例
 */
static  YMDataManager* _sharedInstance;
//地址
static NSArray* _addressArray = nil;

//省市区
static NSArray* _provinceArr = nil;
static NSArray* _citiesArray = nil;
static NSArray* _areasArray = nil;

static dispatch_queue_t serialQueue;
//单例对象
+ (YMDataManager *) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YMDataManager alloc] init];
    });
    return _sharedInstance;
}

//总数组
+(NSArray*)addressArray{
    if (!_addressArray) {
        //读取cityGroups.plist文件; 并解析存储到_cityGroups数组中
        _addressArray = [[self alloc] getAddressArrWithFile:@"dd_areas.json"];
    }
//    DDLog(@"_dddressArr == %@",_addressArray);
    return _addressArray;
}

//省
+(NSArray* )provinceArr{
    if (!_provinceArr) {
        _provinceArr = [[self alloc] getProvinceArrWithAddressArr:[self addressArray]];
    }
    return _provinceArr;
}

//市
+(NSArray* )citiesArray{
    if (!_citiesArray) {
        _citiesArray = [NSArray array];
    }
    return _citiesArray;
}
//区
+(NSArray* )areasArray{
    if (!_areasArray) {
        _areasArray = [NSArray array];
    }
    return _areasArray;
}

//获取省数组
-(NSArray* )getProvinceArrWithAddressArr:(NSArray* )addressArr{
    //湖北省
    NSMutableArray* tmpProvinceArr = [[NSMutableArray alloc]init];
    for (int i  = 0 ; i < addressArr.count; i ++ ) {
        // 湖北 湖南
        YMCityModel* provinceModel = addressArr[i];
        DDLog(@"name ==  %@",provinceModel.name);
        // 武汉市 cityArea
        NSMutableArray* tmpCityArr = [[NSMutableArray alloc]init];
        for (int j = 0 ; j < provinceModel.cityArr.count; j ++ ) {
            YMCityModel* cityModel = [[YMCityModel alloc]init];
            [cityModel setValuesForKeysWithDictionary:provinceModel.cityArr[j]];
            [tmpCityArr addObject:cityModel];
            
            NSMutableArray* tmpAreaArr = [[NSMutableArray alloc]init];
            //武昌区 cityArea
            for (int k = 0 ; k < cityModel.areaArr.count ; k ++) {
                
                YMCityModel* area = [[YMCityModel alloc]init];
                [area setValuesForKeysWithDictionary:cityModel.areaArr[k]];
                [tmpAreaArr addObject:area];
                
                // NSLog(@"cityArr ----- %@",cityModel.areaArr[k]);
                // DDLog(@"area === %@",tmpAreaArr);
            }
            [tmpCityArr addObject:tmpAreaArr];
            DDLog(@"cityArr == %@",tmpCityArr);
        }
        [tmpProvinceArr addObject:tmpCityArr];
        DDLog(@"province == %@",tmpCityArr);
    }
    return [tmpProvinceArr copy];
}

//读取文件二
- (NSArray* )getAddressArrWithFile:(NSString*)fileName{
    NSString* jsonPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    NSArray* jsonArr = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    
    NSMutableArray* tmpAddrsArr = [[NSMutableArray alloc]init];
    //初始化总的大数组
    for (int i = 0 ; i < jsonArr.count; i ++) {
        YMCityModel* city = [[YMCityModel alloc]init];
        [city setValuesForKeysWithDictionary:jsonArr[i]];
        [tmpAddrsArr addObject:city];
    }
    
    DDLog(@"初始化数据 addressArr == %@",tmpAddrsArr);
    
    return [tmpAddrsArr copy];
}

////读取文件1
//- (NSArray* )getArrayFromPlistFile:(NSString*)fileName{
//    NSString* plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
//
////    NSString* plistPath1 = [[NSBundle mainBundle] pathForResource:@"Lovesickness.db" ofType:nil];
////    NSLog(@"fileName ====== %@",plistPath1);
//    NSLog(@"fileName ====== %@",fileName);
//    NSLog(@"plistpath ==== %@",plistPath);
//
//    NSArray* dataArray = [NSArray arrayWithContentsOfFile:plistPath];
//    return [dataArray copy];
//}


//- (NSString *) pathForDataFile {
//    NSArray*    documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString*    path = nil;
//    
//    if (documentDir) {
//        path = [documentDir objectAtIndex:0];
//    }
//    
//    return [NSString stringWithFormat:@"%@/%@", path, @"test.bin"];
//}
//
//- (void) saveDataToDisk:(NSMutableDictionary*)dict
//{
//    NSString * path = [self pathForDataFile];
//    
//    if (dict == nil) {
//        return;
//    }
//    [dict writeToFile:path atomically:YES];
//}
//
//- (NSMutableDictionary*) loadDataFromDisk
//{
//    NSString     * path         = [self pathForDataFile];
//    
//    NSMutableDictionary * rootObject = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
//    if (rootObject == nil) {
//        rootObject = [[NSMutableDictionary alloc] initWithCapacity:0];
//    }
//    return rootObject;
//}

@end
