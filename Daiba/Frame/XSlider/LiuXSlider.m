//
//  LiuXSlider.m
//  LJSlider
//
//  Created by 刘鑫 on 16/3/24.
//  Copyright © 2016年 com.anjubao. All rights reserved.
//

//  git地址：https://github.com/xinge1/LiuXSlider
//

#define SelectViewBgColor   [UIColor colorWithRed:255/255.0 green:109/255.0 blue:0/255.0 alpha:1]
#define defaultViewBgColor  [UIColor lightGrayColor]

#define LiuXSlideWidth      (self.bounds.size.width)
#define LiuXSliderHight     (self.bounds.size.height)

#define LiuXSliderTitle_H   (LiuXSliderHight*.3)

#define CenterImage_W       26.0

#define LiuXSliderLine_W    (LiuXSlideWidth-CenterImage_W)
#define LiuXSLiderLine_H    6.0
//#define LiuXSliderLine_Y    10
                            //(LiuXSliderHight-LiuXSliderTitle_H)

//#define CenterImage_Y       (LiuXSliderLine_Y+(LiuXSLiderLine_H/2))


#import "LiuXSlider.h"

@interface LiuXSlider()
{

    CGFloat _pointX; //
    NSInteger _sectionIndex;//当前选中的那个
    CGFloat _sectionLength; //根据数组分段后一段的长度
    UILabel *_selectLab;    //显示借款钱数的label
    UILabel *_leftLab;   //左边的起始值
    UILabel *_rightLab;  // 右边结束值
}
/**
 *  必传，范围（0到(array.count - 1)）
 */
@property (nonatomic,assign)CGFloat defaultIndx;

/**
 *  必传，传入节点数组
 */
@property (nonatomic,strong)NSArray *titleArray;

/**
 *  首，末位置的title
 */
@property (nonatomic,strong)NSArray *firstAndLastTitles;
/**
 *  传入图片
 */
@property (nonatomic,strong)UIImage *sliderImage;

//进度条 view
@property (strong,nonatomic)UIView *selectView;

@property (strong,nonatomic)UIView *defaultView;
@property (strong,nonatomic)UIImageView *centerImage;
@end

@implementation LiuXSlider


-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray firstAndLastTitles:(NSArray *)firstAndLastTitles defaultIndex:(CGFloat)defaultIndex sliderImage:(UIImage *)sliderImage
{
    if (self  = [super initWithFrame:frame]) {
        _pointX = 0;
        _sectionIndex = 0;
//        self.backgroundColor=[UIColor colorWithWhite:.6 alpha:.1];
        self.backgroundColor = [UIColor clearColor];
        
        _selectLab = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - 200)/2, 0, 200, 30)];
        _selectLab.textColor = DefaultNavBarColor;
        _selectLab.font = [UIFont systemFontOfSize:30];
        _selectLab.textAlignment = 1;
        [self addSubview:_selectLab];
        
        //userInteractionEnabled=YES;代表当前视图可交互，该视图不响应父视图手势
        //UIView的userInteractionEnabled默认是YES，UIImageView默认是NO
        CGFloat sliderLineY = CGRectGetMaxY(_selectLab.frame) + 20;
        _defaultView = [[UIView alloc] initWithFrame:CGRectMake(CenterImage_W/2, sliderLineY , LiuXSlideWidth - CenterImage_W, LiuXSLiderLine_H)];
        _defaultView.backgroundColor    = DefaultBtn_UnableColor;
        _defaultView.layer.cornerRadius = LiuXSLiderLine_H/2;
        _defaultView.userInteractionEnabled = NO;
        [self addSubview:_defaultView];
        
        _selectView=[[UIView alloc] initWithFrame:CGRectMake(CenterImage_W/2, sliderLineY, LiuXSlideWidth-CenterImage_W, LiuXSLiderLine_H)];
        _selectView.backgroundColor = SelectViewBgColor;
        _selectView.layer.cornerRadius = LiuXSLiderLine_H/2;
        _selectView.userInteractionEnabled = NO;
        [self addSubview:_selectView];
        
        CGFloat centerImage_Y = sliderLineY + LiuXSLiderLine_H * 0.5;
        _centerImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CenterImage_W, CenterImage_W)];
        _centerImage.center=CGPointMake(0, centerImage_Y);
        _centerImage.userInteractionEnabled = NO;
        _centerImage.alpha = 1;
        [self addSubview:_centerImage];
        
        //_selectView  左右显示 钱数
        _leftLab = [[UILabel alloc] initWithFrame:CGRectMake(_selectView.x, CGRectGetMaxY(_selectView.frame) + 10,40, LiuXSliderTitle_H)];
        _leftLab.font = [UIFont systemFontOfSize:12];
        _leftLab.textColor = [UIColor lightGrayColor];
        _leftLab.textAlignment = NSTextAlignmentLeft;
        _leftLab.text = [NSString stringWithFormat:@"%@元",[firstAndLastTitles firstObject]];
        [self addSubview:_leftLab];
        
        _rightLab  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectView.frame) - 80, _leftLab.y, 80, LiuXSliderTitle_H)];
        _rightLab.font = [UIFont systemFontOfSize:12];
        _rightLab.textColor = [UIColor lightGrayColor];
        _rightLab.text = [NSString stringWithFormat:@"%@元",[firstAndLastTitles lastObject]];
        _rightLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_rightLab];
        
        self.titleArray  = titleArray;
        
        
        self.defaultIndx = defaultIndex;
        
        
        self.firstAndLastTitles = firstAndLastTitles;
        self.sliderImage = sliderImage;
    }
    return self;
}


-(void)setDefaultIndx:(CGFloat)defaultIndx{
    CGFloat withPress = defaultIndx/(_titleArray.count-1);
    //设置默认位置
    CGRect rect = [_selectView frame];
    rect.size.width   = withPress * LiuXSliderLine_W;
    _selectView.frame = rect;
    
    _pointX = withPress * LiuXSliderLine_W;
    _sectionIndex = defaultIndx;
    
    if (self.block) {
        self.block(_sectionIndex);
    }
}

-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray    = titleArray;
    _sectionLength = (LiuXSliderLine_W/(titleArray.count-1));
    //NSLog(@"(%lu),(%f),(%f)",(unsigned long)titleArray.count,LiuXSliderLine_W,_sectionLength);
}

-(void)setFirstAndLastTitles:(NSArray *)firstAndLastTitles{
    
   
    
}

-(void)setSliderImage:(UIImage *)sliderImage{
    _centerImage.image = sliderImage;
    [self refreshSlider];
}

#pragma mark ---UIColor Touchu
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self changePointX:touch];
    _pointX=_sectionIndex*(_sectionLength);
    [self refreshSlider];
    [self labelEnlargeAnimation];
    //实时更新
    if (self.block) {
        self.block((int)_sectionIndex);
    }
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self changePointX:touch];
    [self refreshSlider];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

//结束更新
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self changePointX:touch];
    _pointX=_sectionIndex*(_sectionLength);
    if (self.block) {
        self.block((int)_sectionIndex);
    }
    [self refreshSlider];
    [self labelLessenAnimation];
    
}
//改变进度条 -- 获取相应的值
-(void)changePointX:(UITouch *)touch{
    CGPoint point = [touch locationInView:self];
    _pointX = point.x;
    if (point.x < 0 ) {
        _pointX = 0 ; // CenterImage_W / 2;
    }else if (point.x >= LiuXSliderLine_W){
        _pointX = LiuXSliderLine_W ;//+ CenterImage_W/2
    }
    //四舍五入计算选择的节点
    //数组越界
    _sectionIndex = (int)roundf(_pointX/_sectionLength);
    if (_sectionIndex >= _titleArray.count - 1) {
        _sectionIndex = _titleArray.count - 1;
    }
    
//        if (point.x < 0 ) {
//            _pointX =  CenterImage_W / 2;
//        }else if (point.x >= LiuXSliderLine_W){
//            _pointX = LiuXSliderLine_W - CenterImage_W/2;
//        }
//        //四舍五入计算选择的节点
//        //数组越界
//        _sectionIndex = (int)roundf((_pointX - CenterImage_W)/(_sectionLength ));
//        if (_sectionIndex >= _titleArray.count - 1) {
//            _sectionIndex = _titleArray.count - 1;
//        }
//    DDLog(@"pointx=(%f),(%ld),(%f)",point.x,(long)_sectionIndex,_pointX);
}

-(void)refreshSlider{
    _pointX = _pointX+CenterImage_W/2;
    _centerImage.center = CGPointMake(_pointX, _selectView.centerY);
    CGRect rect = [_selectView frame];
    rect.size.width=_pointX-CenterImage_W/2;
    _selectView.frame = rect;
    
    //_selectLab.center=CGPointMake(_pointX, 3);
    _selectLab.text=[NSString stringWithFormat:@"¥ %@.00",_titleArray[_sectionIndex]];
    
    //让label 跟着滑块走 可以注释掉
    if (_sectionIndex == 0) {
//        _leftLab.hidden = YES;
//        _selectLab.center = CGPointMake(_pointX, 10);
    }else if (_sectionIndex == _titleArray.count-1) {
//        _rightLab.hidden = YES;
//        _selectLab.center = CGPointMake(_pointX, 10);
    }else{
//        _leftLab.hidden = NO;
//        _rightLab.hidden = NO;
//        _selectLab.center = CGPointMake(_pointX, 7);
    }
    
}

-(void)labelEnlargeAnimation{
    [UIView animateWithDuration:.1 animations:^{
        [_selectLab.layer setValue:@(1.4) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)labelLessenAnimation{
    [UIView animateWithDuration:.1 animations:^{
        [_selectLab.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        
    }];
}

@end
