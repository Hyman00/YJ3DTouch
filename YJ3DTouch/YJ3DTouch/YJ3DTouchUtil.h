//
//  YJ3DTouchUtil.h
//  YJ3DTouch
//
//  Created by hyman on 2017/4/1.
//  Copyright © 2017年 hyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface YJ3DTouchUtil : NSObject

+ (void)safeSwizzleOriginMethod:(SEL)origSel withTargetMethod:(SEL)altSel forClass:(Class)cls;

+ (id)associatedObjectWithkey:(const void *)key forTarget:(id)target;
+ (void)setAssociatedObject:(id)object withKey:(const void *)key policy:(objc_AssociationPolicy)policy forTarget:(id)target;

+ (void)hookTableViewDataSource:(id)dataSource withBlock:(void(^)(UITableViewCell *cell, UITableView *tableView))block;
+ (void)hookCollectionViewDataSource:(id)dataSource withBlock:(void(^)(UICollectionViewCell *cell, UICollectionView *collectionView))block;

@end
