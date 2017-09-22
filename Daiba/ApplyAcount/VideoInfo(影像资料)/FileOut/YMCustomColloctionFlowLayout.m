//
//  YMCustomColloctionFlowLayout.m
//  Daiba
//
//  Created by YouMeng on 2017/8/1.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMCustomColloctionFlowLayout.h"

#define ItemWH  40
#define HZJScaleFactor  20
#define HZJActiveDistance 30

@implementation YMCustomColloctionFlowLayout
//只要显示的边界发生改变就重新布局
//内部会重新调用 prepareLayout 和 layoutAttributesForElementsInRect方 法获得所有cell的布局属性
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds

{
    return YES;
}

//一些初始化工作最好在这里实现,比如设置item大小，滚动方向，等等
- (void)prepareLayout {
    
    [super prepareLayout];
    
    // 每个cell的尺寸
    
    self.itemSize = CGSizeMake(ItemWH,ItemWH);
    
    CGFloat inset = (self.collectionView.frame.size.width - ItemWH) * 0.5;
    
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
    // 设置水平滚动
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.minimumLineSpacing = ItemWH * 0.7;
    
}
- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 0.计算可见的矩形框
    CGRect visiableRect;
    
    visiableRect.size=self.collectionView.frame.size;
    
    visiableRect.origin=self.collectionView.contentOffset;
    
    // 1.取得默认的cell的UICollectionViewLayoutAttributes
    
    NSArray*array = [super layoutAttributesForElementsInRect:rect];
    
    //计算屏幕最中间的x
    
    CGFloat centerX =self.collectionView.contentOffset.x+self.collectionView.frame.size.width*0.5;
    
    // 2.遍历所有的布局属性
    
    for(UICollectionViewLayoutAttributes*attrs in array) {
        
        //如果不在屏幕上,直接跳过
        
        if(!CGRectIntersectsRect(visiableRect, attrs.frame))continue;
        
        //每一个item的中点x
        
        CGFloat itemCenterX = attrs.center.x;
        
        //差距越小,缩放比例越大
        
        //根据跟屏幕最中间的距离计算缩放比例
        
        CGFloat scale = 1 + HZJScaleFactor* (1- (ABS(itemCenterX - centerX) /HZJActiveDistance));
        
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
        
    }
    
    return array;
    
}
//用来设置collectionView停止滚动那一刻的位置 1.proposedContentOffset原本collectionView停止滚动那一刻的位置2.velocity滚动速度
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity

{
    
    // 1.计算出scrollView最后会停留的范围
    CGRect lastRect;
    
    lastRect.origin= proposedContentOffset;
    
    lastRect.size=self.collectionView.frame.size;
    
    //计算屏幕最中间的x
    
    CGFloat centerX = proposedContentOffset.x+self.collectionView.frame.size.width*0.5;
    
    // 2.取出这个范围内的所有属性
    
    NSArray*array = [self layoutAttributesForElementsInRect:lastRect];
    
    // 3.遍历所有属性ABS()计算绝对值
    
    CGFloat adjustOffsetX =MAXFLOAT;
    
    for(UICollectionViewLayoutAttributes*attrs in array) {
        
        if(ABS(attrs.center.x- centerX)){
           
           adjustOffsetX = attrs.center.x - centerX;
           
        }
           
    }
           
    return CGPointMake(proposedContentOffset.x+ adjustOffsetX, proposedContentOffset.y);
           
}
           
     


@end
