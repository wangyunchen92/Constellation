//
//  YMCollectionViewCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMCollectionViewCell.h"


@implementation YMCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithFrame:(CGRect)frame text:(NSString* )text{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[JXTProgressLabel alloc]initWithFrame:frame];
    
        self.titleLabel.font = Font(16);
        self.titleLabel.backgroundColor = LightTextColor;
        self.titleLabel.backgroundTextColor = LightGrayColor;
        self.titleLabel.foregroundTextColor = DefaultNavBarColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
       
        [self addSubview:self.titleLabel];
    }
    return self;
}

//设置UIImageView 的位置是 self.frame 这个位置是相对于整个UICollectionView 的，再添加自定义Cell 上面的时候，就不对了，那个位置是cell相对于父视图 UICollectionView的，添加到Cell 上面的，UIImageView 的父视图是Cell 而不是UICollectionView，所以设置图片视图UIImageView 的位置的时候应该用相对于Cell 位置的self.bounds
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[JXTProgressLabel alloc]initWithFrame:self.bounds];
//        self.titleLabel.text = text;
        self.titleLabel.font = Font(16);
//        self.titleLabel.backgroundColor = LightTextColor;
        self.titleLabel.backgroundTextColor = LightGrayColor;
        self.titleLabel.foregroundTextColor = DefaultNavBarColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
          //上
//        UIView* topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
//        topLineView.backgroundColor = BlackColor;
//        //左
//        UIView* leftLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, frame.size.height)];
//        leftLineView.backgroundColor = BlackColor;
//        //下
//        UIView* bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 1)];
//        bottomLineView.backgroundColor = BlackColor;
//        //右
//        UIView* rightLineView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width, 0, 1, frame.size.height)];
//        rightLineView.backgroundColor = BlackColor;
//
//        //添加边框
//        [self.titleLabel addSubview:topLineView];
//        [self.titleLabel addSubview:leftLineView];
//        [self.titleLabel addSubview:bottomLineView];
//        [self.titleLabel addSubview:rightLineView];

        [self addSubview:self.titleLabel];
    }

    return self;
}

//-(void)setTitleLabel:(JXTProgressLabel *)titleLabel{
//    _titleLabel = titleLabel;
//    _titleLabel = [[JXTProgressLabel alloc]initWithFrame:self.bounds];
//    [self addSubview:_titleLabel];
//}

@end
