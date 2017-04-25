//
//  YJ3DTouchUtil.m
//  YJ3DTouch
//
//  Created by hyman on 2017/4/1.
//  Copyright © 2017年 hyman. All rights reserved.
//

#import "YJ3DTouchUtil.h"
#import <objc/runtime.h>

@implementation YJ3DTouchUtil

+ (void)safeSwizzleOriginMethod:(SEL)origSel withTargetMethod:(SEL)altSel forClass:(Class)cls {    
    if ([self hasSwizzledForTarget:cls swizzleSelector:origSel]) {
        return;
    }
    [self setHasSwizzled:YES forTarget:cls swizzleSelector:origSel];
    
    method_exchangeImplementations(class_getInstanceMethod(cls, origSel),
                                   class_getInstanceMethod(cls, altSel));
}

+ (BOOL)hasSwizzledForTarget:(id)object swizzleSelector:(SEL)selector {
    return [objc_getAssociatedObject(object, selector) boolValue];
}

+ (void)setHasSwizzled:(BOOL)swizzled forTarget:(id)object swizzleSelector:(SEL)selector {
    objc_setAssociatedObject(object,
                             selector,
                             @(swizzled),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 当前类是否覆写了指定接口
+ (BOOL)isClass:(Class)cls overwriteSelector:(SEL)selector
{
    Class superClass = [cls superclass];
    if ([cls instanceMethodForSelector:selector] != [superClass instanceMethodForSelector:selector]) {
        return YES;
    }
    return NO;
}

+ (void)dynamicProcessClass:(Class)cls oriSel:(SEL)oriSel altSel:(SEL)altSel oriImp:(IMP)oriImp altImp:(IMP)altImp
{
    if ([YJ3DTouchUtil hasSwizzledForTarget:cls swizzleSelector:oriSel]) {
        return;
    }
    
    if ([self isClass:cls overwriteSelector:oriSel]) {   // 重载了该接口
        if (class_addMethod(cls, altSel, altImp, "@@:@@")) {
            [self setHasSwizzled:YES forTarget:cls swizzleSelector:oriSel];
            method_exchangeImplementations(class_getInstanceMethod(cls, oriSel),
                                           class_getInstanceMethod(cls, altSel));
        }
    }
    else {
        if (class_addMethod(cls, oriSel, oriImp, "@@:@@")) {
            [YJ3DTouchUtil setHasSwizzled:YES forTarget:cls swizzleSelector:oriSel];
        }
    }
}

@end
