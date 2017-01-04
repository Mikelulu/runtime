//
//  UIViewController+Tracking.m
//  Runtime
//
//  Created by Mike on 2017/1/4.
//  Copyright © 2017年 LK. All rights reserved.
//

/*
 Method Swizzling(方法交叉)
 */
#import "UIViewController+Tracking.h"
#import <objc/runtime.h>

@implementation UIViewController (Tracking)
/*
 +load 和 +initialize两个方法
 
 Method Swizzling要在+load进行
 
 这两个方法都是Runtime中自动调用的方法。其中
 
 +load在每个类被装载到Runtime的时候调用
 +initialize 在每个类第一次被发送消息的时候调用。
 之所以要在+load中进行，是因为方法交叉影响的是全局状态，+load中能保证在class 装载的时候进行交叉，而initialize没办法做到。
 */
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}
- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", self);
}
/*
 根据@selector(viewWillAppear:)找到自定义的xxx_viewWillAppear实现
 自定义的xxx_viewWillAppear实现，向Self发送@selector(xxx_viewWillAppear)
 根据@selector(xxx_viewWillAppear)，找到默认的SDK中viewWillAppear的实现
 执行默认SDK中viewWillAppear代码
 执行NSLog(@"viewWillAppear: %@", self);
 结束
 */
@end
