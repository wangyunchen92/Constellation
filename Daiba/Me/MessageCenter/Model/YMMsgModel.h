//
//  YMMsgModel.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/20.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseModel.h"

@interface YMMsgModel : BaseModel


//from_id
@property(nonatomic,strong)NSString* from_id;

//user_id
@property(nonatomic,strong)NSString* user_id;

//msgId
@property(nonatomic,strong)NSString* id;
//消息类型，1:系统消息 2:评价消息3:付款
@property(nonatomic,strong)NSString* type;
// 消息标题
@property(nonatomic,strong)NSString* title;

//消息内容
@property(nonatomic,strong)NSString* content;
//消息状态： 0待推送 1已经推送 2推送失败  //添加时间
@property(nonatomic,strong)NSString* add_time;
//阅读状态：0未读 1已读
@property(nonatomic,strong)NSString* status;


//消息描述
@property(nonatomic,strong)NSString* desc;

//消息对象类型 1:用户消息 2:商铺消息
@property(nonatomic,strong)NSString* object_type;
//消息对象的编码，若系统则为0
@property(nonatomic,strong)NSString* object_id;

@property(nonatomic,strong)NSString* imgs;

@property(nonatomic,strong)NSString* img;


//图片的高度
@property(nonatomic,assign)CGFloat imgHeight;
@property(nonatomic,assign)CGFloat heigh;

//文字是否显示全文
@property(nonatomic,assign)BOOL isOpen;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;
//文字的高度
@property(nonatomic,assign)CGFloat contentHeight;
@property(nonatomic,assign)CGFloat textHeight;


@end
