//
//  SelectPickerView.h
//  Lovesickness
//
//  Created by w gq on 15/8/3.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectPickerDelegate <NSObject>
//滚动自动调用
- (void)pickerView:(UIPickerView *)pickerView changeValue:(NSDictionary *)param;
//点击确定按钮
- (void)pickerView:(UIPickerView *)pickerView doneValue:(NSDictionary *)param;
//点击取消按钮
- (void)pickerView:(UIPickerView *)pickerView cancelValue:(NSDictionary*)param;
@end

@interface SelectPickerView : UIView

@property (nonatomic ,retain) id <SelectPickerDelegate> delegate;

@property (nonatomic,strong)NSString *type;

//存放键值对
//@property(nonatomic,strong)NSDictionary* allDataDic;

//原始数据
@property(nonatomic,strong)NSArray* metaDataArr;

//添加数组数据 pickView会按多少数组自动分区显示
@property (nonatomic,strong)NSArray *allData;
//中间数据

//后缀
@property (nonatomic,strong)NSArray *suffix;
//第一个后缀
@property (nonatomic,strong)NSArray *firstSuffix;
//最后一个后缀
@property (nonatomic,strong)NSArray *lastSuffix;


@end
