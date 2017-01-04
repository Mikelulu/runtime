//
//  UIView+LKExtension.m
//  Runtime
//
//  Created by Mike on 2017/1/4.
//  Copyright © 2017年 LK. All rights reserved.
//

#import "UIView+LKExtension.h"
#import <objc/runtime.h>

static const char kAnaylizeTitle;

@implementation UIView (LKExtension)

- (NSString *)lk_anaylizeTitle
{
    return objc_getAssociatedObject(self, &kAnaylizeTitle);
}

- (void)setLk_anaylizeTitle:(NSString *)lk_anaylizeTitle
{
    objc_setAssociatedObject(self, &kAnaylizeTitle, lk_anaylizeTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
