//
//  UIViewController+YJ3DTouch.m
//  YJ3DTouch
//
//  Created by hyman on 2017/3/31.
//  Copyright © 2017年 hyman. All rights reserved.
//

#import "UIViewController+YJ3DTouch.h"
#import <objc/runtime.h>
#import "YJ3DTouchUtil.h"

#pragma mark - YJ3DTouch_VC
@interface UIViewController (YJ3DTouch_VC)
@end

@implementation UIViewController (YJ3DTouch_VC)

- (UIViewController *)yj3d_private_detailVC {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)yj3d_private_setDetailVC:(UIViewController *)detailVC {
    objc_setAssociatedObject(self, @selector(yj3d_private_detailVC), detailVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yj3d_private_activePresent3DTouch {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)yj3d_private_setActivePresent3DTouch:(BOOL)active {
    objc_setAssociatedObject(self, @selector(yj3d_private_activePresent3DTouch), @(active), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)yj3d_private_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if ([self yj3d_private_activePresent3DTouch]) {
        [self yj3d_private_setActivePresent3DTouch:NO];
        [self yj3d_private_setDetailVC:viewControllerToPresent];
        return;
    }
    
    [self yj3d_private_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end

#pragma mark - YJ3DTouch_Nav
@interface UINavigationController (YJ3DTouch_Nav)
@end

@implementation UINavigationController (YJ3DTouch_Nav)

- (void)yj3d_private_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self yj3d_private_activePush3DTouch]) {
        [self yj3d_private_setActivePush3DTouch:NO];
        [self yj3d_private_setDetailVC:viewController];
        return;
    }
    
    [self yj3d_private_pushViewController:viewController animated:animated];
}

- (BOOL)yj3d_private_activePush3DTouch {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)yj3d_private_setActivePush3DTouch:(BOOL)active {
    objc_setAssociatedObject(self, @selector(yj3d_private_activePush3DTouch), @(active), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark - YJ3DTouch_View
@interface UIView (YJ3DTouch_View)
@end

@implementation UIView (YJ3DTouch_View)

- (UIViewController<UIViewControllerPreviewingDelegate> *)yj3d_private_previewDelegateController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)yj3d_private_setPreviewDelegateController:(UIViewController *)viewController {
    objc_setAssociatedObject(self, @selector(yj3d_private_previewDelegateController), viewController, OBJC_ASSOCIATION_ASSIGN);
}

- (YJ3DTouchConfig *)yj3d_private_3DTouchConfig {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)yj3d_private_set3DTouchConfig:(YJ3DTouchConfig *)config {
    objc_setAssociatedObject(self, @selector(yj3d_private_3DTouchConfig), config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yj3d_private_hasRegistered3DTouch {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)yj3d_private_setHasRegistered3DTouch:(BOOL)registered {
    objc_setAssociatedObject(self, @selector(yj3d_private_hasRegistered3DTouch), @(registered), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark - YJ3DTouch_Cell
@interface UITableViewCell (YJ3DTouch_Cell)
@end

@implementation UITableViewCell (YJ3DTouch_Cell)

- (UITableView *)yj3d_private_cell_tableView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)yj3d_private_cell_setTableView:(UITableView *)tableView {
    objc_setAssociatedObject(self, @selector(yj3d_private_cell_tableView), tableView, OBJC_ASSOCIATION_ASSIGN);
}

@end

#pragma mark - YJ3DTouch_TableView_Delegate
@interface NSObject (YJ3DTouch_TableView_Delegate)
@end

@implementation NSObject (YJ3DTouch_TableView_Delegate)

- (UITableViewCell *)yj3d_private_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self yj3d_private_tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell yj3d_private_hasRegistered3DTouch] == NO) {
        [cell yj3d_private_setHasRegistered3DTouch:YES];
        
        UIViewController<UIViewControllerPreviewingDelegate> *vc = [tableView yj3d_private_previewDelegateController];
        [vc registerForPreviewingWithDelegate:vc sourceView:cell];
        
        [cell yj3d_private_cell_setTableView:tableView];
    }
    
    return cell;
}

@end


#pragma mark - UIViewController YJ3DTouch
@implementation UIViewController (YJ3DTouch)

- (BOOL)yj_previewing3DTouch {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)yj3d_private_setYJ_previewing3DTouch:(BOOL)previewing {
    objc_setAssociatedObject(self, @selector(yj_previewing3DTouch), @(previewing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)yj_active3DTouchTable:(UITableView *)tableView forNavigation:(UINavigationController *)navigation
{
    if ([self yj3d_private_support3DTouch] == NO) {
        return;
    }
    
    YJ3DTouchConfig *config = [YJ3DTouchConfig new];
    config.navigation = navigation;
    [self yj_active3DTouchView:tableView touchConfig:config];
}

- (void)yj_active3DTouchControl:(UIControl *)control
                         target:(NSObject *)target
                         action:(SEL)action
                  forNavigation:(UINavigationController *)navigation
{
    if ([self yj3d_private_support3DTouch] == NO) {
        return;
    }
    
    YJ3DTouchConfig *config = [YJ3DTouchConfig new];
    config.navigation = navigation;
    config.customActionTarget = target;
    config.customAction = action;
    [self yj_active3DTouchView:control touchConfig:config];
}

- (void)yj_active3DTouchView:(UIView *)view touchConfig:(YJ3DTouchConfig *)touchConfig {
    if ([self yj3d_private_support3DTouch] == NO || [view yj3d_private_hasRegistered3DTouch]) {
        return;
    }
    
    [view yj3d_private_setPreviewDelegateController:self];
    [view yj3d_private_set3DTouchConfig:touchConfig];
    
    if (touchConfig.navigation) {
        [YJ3DTouchUtil safeSwizzleOriginMethod:@selector(pushViewController:animated:)
                              withTargetMethod:@selector(yj3d_private_pushViewController:animated:)
                                     forClass:[UINavigationController class]];
    } else if (touchConfig.presentingViewController) {
        [YJ3DTouchUtil safeSwizzleOriginMethod:@selector(presentViewController:animated:completion:)
                              withTargetMethod:@selector(yj3d_private_presentViewController:animated:completion:)
                                     forClass:[UIViewController class]];
    }
    
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)view;
        [YJ3DTouchUtil safeSwizzleOriginMethod:@selector(tableView:cellForRowAtIndexPath:)
                              withTargetMethod:@selector(yj3d_private_tableView:cellForRowAtIndexPath:)
                                     forClass:[tableView.dataSource class]];
    } else {
        [self registerForPreviewingWithDelegate:self sourceView:view];
        [view yj3d_private_setHasRegistered3DTouch:YES];
    }
}

// previewController will call this method, eg: detailVC
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIView *currentPreviewingView = [self yj3d_private_currentPreviewingView];
    YJ3DTouchConfig *config = [currentPreviewingView yj3d_private_3DTouchConfig];
    return config.previewActionItems;
}

#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext
              viewControllerForLocation:(CGPoint)location
{
    UIViewController *detailVC = nil;
    
    UIView *sourceView = [previewingContext sourceView];
    
    YJ3DTouchConfig *config = nil;
    if ([sourceView isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)sourceView;
        UITableView *tableView = [cell yj3d_private_cell_tableView];
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        
        config = [tableView yj3d_private_3DTouchConfig];

        if (config.navigation) {
            [config.navigation yj3d_private_setActivePush3DTouch:YES];
        } else {
            [config.presentingViewController yj3d_private_setActivePresent3DTouch:YES];
        }
        
        [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        config = [sourceView yj3d_private_3DTouchConfig];

        if (config.navigation) {
            [config.navigation yj3d_private_setActivePush3DTouch:YES];
        } else {
            [config.presentingViewController yj3d_private_setActivePresent3DTouch:YES];
        }
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [config.customActionTarget performSelector:config.customAction withObject:sourceView];
#pragma clang diagnostic pop
    }
    
    detailVC = [(config.navigation ?: config.presentingViewController) yj3d_private_detailVC];
    
    [(config.navigation ?: config.presentingViewController) yj3d_private_setDetailVC:nil];
    [detailVC yj3d_private_setCurrentPreviewingView:sourceView];
    
    [detailVC yj3d_private_setYJ_previewing3DTouch:YES];
    
    return detailVC;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext
     commitViewController:(UIViewController *)viewControllerToCommit
{
    [viewControllerToCommit yj3d_private_setYJ_previewing3DTouch:NO];
    
    YJ3DTouchConfig *config = nil;
    UIView *sourceView = [previewingContext sourceView];
    if ([sourceView isKindOfClass:[UITableViewCell class]]) {
        UITableView *tableView = [(UITableViewCell *)sourceView yj3d_private_cell_tableView];
        config = [tableView yj3d_private_3DTouchConfig];
    } else {
        config = [sourceView yj3d_private_3DTouchConfig];
    }

    if (config.navigation) {
        [config.navigation pushViewController:viewControllerToCommit animated:YES];
    } else if (config.presentingViewController) {
        [config.presentingViewController presentViewController:viewControllerToCommit animated:YES completion:nil];
    }
}

#pragma mark - Private
- (BOOL)yj3d_private_support3DTouch {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    }
    
    return [UIApplication sharedApplication].keyWindow.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
}

- (UIView *)yj3d_private_currentPreviewingView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)yj3d_private_setCurrentPreviewingView:(UIView *)view {
    objc_setAssociatedObject(self, @selector(yj3d_private_currentPreviewingView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
