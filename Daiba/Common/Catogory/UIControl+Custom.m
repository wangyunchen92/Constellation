//
//  UIControl+Custom.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/21.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "UIControl+Custom.h"
#import <objc/runtime.h>



//static const int block_key;
//
//@interface _LFUIControlBlockTarget : NSObject
//
//@property (nonatomic, copy) void (^block)(id sender);
//
//@property (nonatomic, assign) UIControlEvents events;
//
//- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events;
//
//- (void)invoke:(id)sender;
//
//@end
//
//@implementation _LFUIControlBlockTarget
//
//- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events {
//    self = [super init];
//    if (self) {
//        self.block = block;
//        self.events = events;
//    }
//    return self;
//}
//
//- (void)invoke:(id)sender {
//    if (self.block)
//        self.block(sender);
//}
//
//@end
//

@interface UIControl()

@property (nonatomic, assign) NSTimeInterval custom_acceptEventTime;

@end

//实现方法交换(妥善的做法是：先添加方法，如果方法已经存在，就替换原方法)
@implementation UIControl (Custom)

+ (void)load{
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method customMethod = class_getInstanceMethod(self, @selector(custom_sendAction:to:forEvent:));
    SEL customSEL = @selector(custom_sendAction:to:forEvent:);
    
    //添加方法 语法：BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types) 若添加成功则返回No
    // cls：被添加方法的类  name：被添加方法方法名  imp：被添加方法的实现函数  types：被添加方法的实现函数的返回值类型和参数类型的字符串
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
    
    //如果系统中该方法已经存在了，则替换系统的方法  语法：IMP class_replaceMethod(Class cls, SEL name, IMP imp,const char *types)
    if (didAddMethod) {
        class_replaceMethod(self, customSEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, customMethod);
        
    }
}

- (NSTimeInterval )custom_acceptEventInterval{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue];
}

- (void)setCustom_acceptEventInterval:(NSTimeInterval)custom_acceptEventInterval{
    objc_setAssociatedObject(self, "UIControl_acceptEventInterval", @(custom_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )custom_acceptEventTime{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventTime") doubleValue];
}

- (void)setCustom_acceptEventTime:(NSTimeInterval)custom_acceptEventTime{
    objc_setAssociatedObject(self, "UIControl_acceptEventTime", @(custom_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)custom_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    // 如果想要设置统一的间隔时间，可以在此处加上以下几句
    // 值得提醒一下：如果这里设置了统一的时间间隔，会影响UISwitch,如果想统一设置，又不想影响UISwitch，建议将UIControl分类，改成UIButton分类，实现方法是一样的
//     if (self.custom_acceptEventInterval <= 0) {
//         // 如果没有自定义时间间隔，则默认为2秒
//        self.custom_acceptEventInterval = 2;
//     }
    
    // 是否小于设定的时间间隔
    BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.custom_acceptEventTime >= self.custom_acceptEventInterval);
    
    // 更新上一次点击时间戳
    if (self.custom_acceptEventInterval > 0) {
        self.custom_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    // 两次点击的时间间隔小于设定的时间间隔时，才执行响应事件
    if (needSendAction) {
        [self custom_sendAction:action to:target forEvent:event];
    }else{
        [MBProgressHUD showFail:@"您的操作太过频繁，请稍后再试！" view:self.window];
    }
    
}


//#pragma mark - 新增方法
//- (void)removeAllTargets {
//    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
//        [self   removeTarget:object
//                      action:NULL
//            forControlEvents:UIControlEventAllEvents];
//    }];
//}
//
//- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
//    NSSet *targets = [self allTargets];
//    for (id currentTarget in targets) {
//        NSArray *actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents];
//        for (NSString *currentAction in actions) {
//            [self   removeTarget:currentTarget action:NSSelectorFromString(currentAction)
//                forControlEvents:controlEvents];
//        }
//    }
//    [self addTarget:target action:action forControlEvents:controlEvents];
//}
//
//- (void)addBlockForControlEvents:(UIControlEvents)controlEvents
//                           block:(void (^)(id sender))block {
//    _LFUIControlBlockTarget *target = [[_LFUIControlBlockTarget alloc]
//                                       initWithBlock:block events:controlEvents];
//    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
//    NSMutableArray *targets = [self _lf_allUIControlBlockTargets];
//    [targets addObject:target];
//}
//
//- (void)setBlockForControlEvents:(UIControlEvents)controlEvents
//                           block:(void (^)(id sender))block {
//    [self removeAllBlocksForControlEvents:controlEvents];
//    [self addBlockForControlEvents:controlEvents block:block];
//}
//
//- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents {
//    NSMutableArray *targets = [self _lf_allUIControlBlockTargets];
//    NSMutableArray *removes = [NSMutableArray array];
//    [targets enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
//        _LFUIControlBlockTarget *target = (_LFUIControlBlockTarget *)obj;
//        if (target.events == controlEvents) {
//            [removes addObject:target];
//            [self   removeTarget:target
//                          action:@selector(invoke:)
//                forControlEvents:controlEvents];
//        }
//    }];
//    [targets removeObjectsInArray:removes];
//}
//
//- (NSMutableArray *)_lf_allUIControlBlockTargets {
//    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
//    if (!targets) {
//        targets = [NSMutableArray array];
//        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    return targets;
//}


@end
