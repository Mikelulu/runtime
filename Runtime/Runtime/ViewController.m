//
//  ViewController.m
//  Runtime
//
//  Created by Mike on 2017/1/4.
//  Copyright © 2017年 LK. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "CustomObject.h"

@interface ViewController ()

@property (nonatomic,strong) CustomObject *myObj;

@property (nonatomic)SEL methodToInvoke;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //消息转发
    self.myObj = [[CustomObject alloc] init];
    
    [self performSelector:@selector(dynamicSelector) withObject:nil];
    
    //用SEL属性来动态执行方法
    int a = arc4random()%2;
    _methodToInvoke = NSSelectorFromString([[self numToSelector] objectForKey:@(a)]);
    
    [self performSelector:_methodToInvoke withObject:nil];
}

#pragma mark -消息转发
void myMehtod(id self,SEL _cmd){
    NSLog(@"This is added dynamic");
}

//方法的动态解析
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSLog(@"方法的动态解析");
    // 指定对某一个方法的动态解析
    NSString *selName = NSStringFromSelector(sel);
    if ([selName isEqualToString:@"dynamicSelector"]) {
        // 动态的添加一个方法
        /**
         <#Description#>

         @param cls#>   <#cls#> 想要添加的类对象
         @param name#>  <#name#> 添加后的方法Selector名字
         @param imp#>   <#imp#> 具体的方法实现
         @param types#> <#types#> description#>

         @return YES 表示本类已经能够处理，NO表示需要消息转发机制。
         */
        class_addMethod([self class], sel, (IMP)myMehtod, "v@:");
        return YES;
    }else{
       return [super resolveInstanceMethod:sel];
    }
}
/*
 2.备用接收者(第一步不能处理的情况下,调用forwardingTargetForSelector来简单的把执行任务转发给另一个对象)
 */
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSLog(@"备用接收者");
    if (aSelector == @selector(dynamicSelector) && [self.myObj respondsToSelector:@selector(dynamicSelector)]) {
        
        return self.myObj;
    }else{
        
        return [super forwardingTargetForSelector:aSelector];
    }
}
/**
 3.完整的消息转发(当前两步都不能处理的时候，调用forwardInvocation转发给别人，返回值仍然返回给最初的Selecto)
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
      NSLog(@"指定方法签名");
    return [CustomObject instanceMethodSignatureForSelector:aSelector];
    
//    NSString *selName = NSStringFromSelector(aSelector);
//    if ([selName isEqualToString:@"dynamicSelector"]) {
//        
//        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    }
//      return [super methodSignatureForSelector:aSelector];
}

#pragma mark --用SEL属性来动态执行方法
//经常会根据后台的Json来执行不同的方法，一两个还好，如果是10个20个，用if else或者switch都是很坑爹的设计。
- (NSDictionary *)numToSelector
{
    return @{@(0):@"method1",
             @(1):@"method2"};
}
- (void)method1
{
    NSLog(@"method1");
}
- (void)method2
{
    NSLog(@"method2");
}
@end
