//
//  YJ3DTouchUtil.m
//  YJ3DTouch
//
//  Created by hyman on 2017/4/1.
//  Copyright © 2017年 hyman. All rights reserved.
//

#import "YJ3DTouchUtil.h"

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

@end
