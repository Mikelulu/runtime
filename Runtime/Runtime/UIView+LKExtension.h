//
//  UIView+LKExtension.h
//  Runtime
//
//  Created by Mike on 2017/1/4.
//  Copyright © 2017年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface UIView (LKExtension)

//objc_setAssociatedObject
//objc_getAssociatedObject
//这两个方法是为一个对象设置关联对象，等价于添加一个属性

@property (nonatomic, copy) NSString *lk_anaylizeTitle;

@end
