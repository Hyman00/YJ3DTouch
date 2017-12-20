//
//  YJ3DTouchUtil.m
//  YJ3DTouch
//
//  Created by hyman on 2017/4/1.
//  Copyright © 2017年 hyman. All rights reserved.
//

#import "YJ3DTouchUtil.h"

#pragma mark - YJ3DWeakAssociateContainer
@interface YJ3DWeakAssociateContainer : NSObject
@property (nonatomic, weak) id obj;
@end

@implementation YJ3DWeakAssociateContainer
@end

#pragma mark - YJ3DTouchUtil
@implementation YJ3DTouchUtil

+ (void)hookTableViewDataSource:(id)dataSource withBlock:(void(^)(UITableViewCell *cell, UITableView *tableView))block {
    Class targetClass = [dataSource class];
    SEL originSEL = @selector(tableView:cellForRowAtIndexPath:);
    if ([self hasSwizzledForTarget:targetClass swizzleSelector:originSEL]) {
        return;
    }
    [self setHasSwizzled:YES forTarget:targetClass swizzleSelector:originSEL];
    
    Method originMethod = class_getInstanceMethod(targetClass, originSEL);
    UITableViewCell *(*originIMP)(__unsafe_unretained id, SEL, __strong id, __strong id) = NULL;
    originIMP = (__typeof__(originIMP))method_getImplementation(originMethod);

    __block id targetBlock = ^UITableViewCell *(__unsafe_unretained id obj,UITableView *tableView, NSIndexPath *indexPath){
        UITableViewCell *cell = originIMP(obj, originSEL, tableView, indexPath);
        block(cell, tableView);
        return cell;
    };

    IMP targetIMP = imp_implementationWithBlock(targetBlock);
    method_setImplementation(originMethod, targetIMP);
}

+ (void)hookCollectionViewDataSource:(id)dataSource withBlock:(void(^)(UICollectionViewCell *cell, UICollectionView *collectionView))block {
    Class targetClass = [dataSource class];
    SEL originSEL = @selector(collectionView:cellForItemAtIndexPath:);
    if ([self hasSwizzledForTarget:targetClass swizzleSelector:originSEL]) {
        return;
    }
    [self setHasSwizzled:YES forTarget:targetClass swizzleSelector:originSEL];
    
    Method originMethod = class_getInstanceMethod(targetClass, originSEL);
    UICollectionViewCell *(*originIMP)(__unsafe_unretained id, SEL, __strong id, __strong id) = NULL;
    originIMP = (__typeof__(originIMP))method_getImplementation(originMethod);
    
    __block id targetBlock = ^UICollectionViewCell *(__unsafe_unretained id obj,UICollectionView *collectionView, NSIndexPath *indexPath){
        UICollectionViewCell *cell = originIMP(obj, originSEL, collectionView, indexPath);
        block(cell, collectionView);
        return cell;
    };
    
    IMP targetIMP = imp_implementationWithBlock(targetBlock);
    method_setImplementation(originMethod, targetIMP);
}

+ (void)safeSwizzleOriginMethod:(SEL)origSel withTargetMethod:(SEL)altSel forClass:(Class)cls {    
    if ([self hasSwizzledForTarget:cls swizzleSelector:origSel]) {
        return;
    }
    [self setHasSwizzled:YES forTarget:cls swizzleSelector:origSel];
    
    method_exchangeImplementations(class_getInstanceMethod(cls, origSel),
                                   class_getInstanceMethod(cls, altSel));
}

+ (id)associatedObjectWithkey:(const void *)key forTarget:(id)target {
    if (target == nil) {
        return nil;
    }
    
    id object = objc_getAssociatedObject(target, key);
    if ([object isKindOfClass:[YJ3DWeakAssociateContainer class]]) {
        return [(YJ3DWeakAssociateContainer *)object obj];
    }
    
    return object;
}

+ (void)setAssociatedObject:(id)object withKey:(const void *)key policy:(objc_AssociationPolicy)policy forTarget:(id)target {
    if (target == nil) {
        return;
    }
    
    if (policy == OBJC_ASSOCIATION_ASSIGN) {
        YJ3DWeakAssociateContainer *container = nil;
        if (object) {
            container = objc_getAssociatedObject(target, key);
            if (container == nil || [container isKindOfClass:[YJ3DWeakAssociateContainer class]] == NO) {
                container = [YJ3DWeakAssociateContainer new];
            }
            container.obj = object;
        }
        objc_setAssociatedObject(target, key, container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(target, key, object, policy);
    }
}

#pragma mark - Private
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
