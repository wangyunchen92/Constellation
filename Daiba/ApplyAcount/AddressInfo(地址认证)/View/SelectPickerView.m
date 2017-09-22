//
//  SelectPickerView.m
//  Lovesickness
//
//  Created by w gq on 15/8/3.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "SelectPickerView.h"
#import "ExtendButton.h"
#import "YMCityModel.h"


@interface SelectPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)UIPickerView *pickerView;

//省 市 区
@property(nonatomic,strong)NSMutableArray* provinceArr;
@property(nonatomic,strong)NSMutableArray* citiesArr;
@property(nonatomic,strong)NSMutableArray* areasArr;

//选中数组
@property(nonatomic,strong)NSMutableArray* selectCityArr;
@end

@implementation SelectPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect datePickerFrame = CGRectMake(0.0, 44.5, SCREEN_WIDTH, 156);//216
        self.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 200);//260
        UIToolbar *toolbar = [[UIToolbar alloc]
                              initWithFrame: CGRectMake(0.0, 0.0, SCREEN_WIDTH, datePickerFrame.origin.y - 0.5)];
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, datePickerFrame.origin.y - 1, SCREEN_WIDTH, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        [toolbar addSubview:view];
        NSLog(@"宽：%f，高：%f",self.frame.size.width,datePickerFrame.origin.y - 0.5);
        //工具栏 按钮设置
        ExtendButton* doneBn = [[ExtendButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 40, 40)];
        [doneBn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
        [doneBn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBn setTitleColor:DefaultNavBarColor forState:UIControlStateNormal];
        
        ExtendButton* cancelBn = [[ExtendButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [cancelBn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [cancelBn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBn setTitleColor:DefaultNavBarColor forState:UIControlStateNormal];

        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithCustomView:cancelBn];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                      target: self
                                      action: nil];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:doneBn];
        [toolbar setItems: @[cancelButton, flexSpace, doneBtn]
                 animated: YES];
        [toolbar setBarTintColor:WhiteColor];
        [toolbar setBackgroundColor:BackGroundColor];
        [self addSubview: toolbar];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH,156)];//254
        self.pickerView.delegate = self;
        
        self.pickerView.showsSelectionIndicator=YES;
        [self addSubview:self.pickerView];
        self.pickerView.backgroundColor = WhiteColor;
        
    }
    return self;
}


//展示数据数组  初视化 数组
-(NSArray *)allData{
    if (!_allData) {
        _allData = @[self.provinceArr,self.citiesArr,self.areasArr];
    }
    return _allData;
}



-(NSMutableArray *)provinceArr{
    if (!_provinceArr) {
        _provinceArr = [[NSMutableArray alloc]init];
        for (YMCityModel* model in self.metaDataArr) {
            [_provinceArr addObject:model.name];
        }
    }
    return _provinceArr;
}

-(NSMutableArray* )citiesArr{
    if (!_citiesArr) {
        _citiesArr = [[NSMutableArray alloc]init];
        YMCityModel* model = self.metaDataArr[0];
        //默认选中第一个
        self.selectCityArr = model.cityArr.mutableCopy;
        for (NSDictionary* cityDic in model.cityArr) {
            [_citiesArr addObject:cityDic[@"name"]];
        }
    }
    return _citiesArr;
}
-(NSMutableArray *)areasArr{
    if (!_areasArr) {
        _areasArr = [[NSMutableArray alloc]init];
        NSDictionary* cityDic = self.selectCityArr[0];
        if (![YMTool isNull:cityDic[@"areaArr"]]) {
            for (NSDictionary * areaDic in cityDic[@"areaArr"]) {
                [_areasArr addObject:areaDic[@"name"]];
            }
        }
    }
    return _areasArr;
}


//波动pickerview 中的任一列 都会响应
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.numberOfComponents > 1) {
        if (component == 0) {
            //1 获取第一列中搏动后选中的 对象
            YMCityModel* model = self.metaDataArr[row];
            // 2 根据这个字母名 找到对应的城市名 ，数据存到第二列对应的数组中
            self.selectCityArr = model.cityArr.mutableCopy;
            //刷新右边的pickview控件
            NSMutableArray* tmpCitiesArr = [[NSMutableArray alloc]init];
            for (NSDictionary* cityDic in self.selectCityArr) {
                [tmpCitiesArr addObject:cityDic[@"name"]];
            }
            self.citiesArr = tmpCitiesArr;
            
            NSMutableArray* tmpAreaArr = [[NSMutableArray alloc]init];
            NSDictionary * cityDic = self.selectCityArr[0];
            if (![YMTool isNull:cityDic[@"areaArr"]]) {
                for (NSDictionary * areaDic in cityDic[@"areaArr"]) {
                    [tmpAreaArr addObject:areaDic[@"name"]];
                }
                self.areasArr = tmpAreaArr;
            }else{
                self.areasArr = @[cityDic[@"name"]].mutableCopy;
            }
            self.allData = @[self.provinceArr,self.citiesArr,self.areasArr];
            //修改第二列第一行被选中
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:1];
            //修改第3列第一行被选中
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        }
    }
        //修改第一列
    if (component == 1) {
        //刷新右边的pickview控件
        NSMutableArray* tmpCitiesArr = [[NSMutableArray alloc]init];
        for (NSDictionary* cityDic in self.selectCityArr) {
            [tmpCitiesArr addObject:cityDic[@"name"]];
        }
        self.citiesArr = tmpCitiesArr;
        
        NSMutableArray* tmpAreaArr = [[NSMutableArray alloc]init];
        NSDictionary * cityDic = self.selectCityArr[row];
        if (![YMTool isNull:cityDic[@"areaArr"]]) {
            for (NSDictionary * areaDic in cityDic[@"areaArr"]) {
                [tmpAreaArr addObject:areaDic[@"name"]];
            }
            self.areasArr = tmpAreaArr;
        }else{
            //没有区默认选择 市
            self.areasArr = @[cityDic[@"name"]].mutableCopy;
        }
         self.allData = @[self.provinceArr,self.citiesArr,self.areasArr];
        
        //修改第二列第一行被选中
        [pickerView selectRow:row inComponent:1 animated:YES];
        //修改第3列第一行被选中
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
    }

    //   把值传到
    NSDictionary *param = [self change];
    if ([self.delegate respondsToSelector:@selector(pickerView:changeValue:)]) {
        [self.delegate pickerView:self.pickerView changeValue:param];
    }
}
//获取选择内容
-(NSDictionary *)change{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.allData.count ; i ++) {
        NSInteger comSelect = [self.pickerView selectedRowInComponent:i];
        NSString * key = [NSString stringWithFormat:@"component%d",i];
        
        param[key] = self.allData[i][comSelect];
    }
    
    if (self.type) {
        param[@"type"] = self.type;
    }
    return [param copy];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.allData.count;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   return  [self.allData[component] count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //是否是第一个
    if (component <self.firstSuffix.count && self.firstSuffix[component] && row == 0) {
        return [NSString stringWithFormat:@"%@%@%@",self.allData[component][row],self.suffix[component],self.firstSuffix[component]];
    }
    //是否是最后一个
    if (component <self.firstSuffix.count && self.firstSuffix[component] && row==[self.allData[component] count]-1) {
        return [NSString stringWithFormat:@"%@%@%@",self.allData[component][row],self.suffix[component],self.lastSuffix[component]];
    }
    //是否存在后缀
    if (component < self.suffix.count && self.suffix[component]) {
        return [NSString stringWithFormat:@"%@%@",self.allData[component][row],self.suffix[component]];
    }
    return self.allData[component][row];
}

-(void)doneClick{
    
    NSDictionary *param = [self change];
    if ([self.delegate respondsToSelector:@selector(pickerView:doneValue:)]) {
        [self.delegate pickerView:self.pickerView doneValue:param];
    }
}
-(void)cancelClick{
    NSDictionary *param = [self change];
    if ([self.delegate respondsToSelector:@selector(pickerView:cancelValue:)]) {
        [self.delegate pickerView:self.pickerView cancelValue:param];
    }
}


@end
