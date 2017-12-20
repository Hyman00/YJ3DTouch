//
//  UIViewController+YJ3DTouch.m
//  YJ3DTouch
//
//  Created by hyman on 2017/3/31.
//  Copyright © 2017年 hyman. All rights reserved.
//

#import "UIViewController+YJ3DTouch.h"
#import "YJ3DTouchUtil.h"
#import <objc/runtime.h>

#pragma mark - YJ3DTouch_VC
@interface UIViewController (YJ3DTouch_VC)
@end

@implementation UIViewController (YJ3DTouch_VC)

- (UIViewController *)yj3d_private_detailVC {
    return [YJ3DTouchUtil associatedObjectWithkey:_cmd forTarget:self];
}

- (void)yj3d_private_setDetailVC:(UIViewController *)detailVC {
    [YJ3DTouchUtil setAssociatedObject:detailVC withKey:@selector(yj3d_private_detailVC) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC forTarget:self];
}

- (UIViewController *)yj3d_private_hostVC {
    return [YJ3DTouchUtil associatedObjectWithkey:_cmd forTarget:self];
}

- (void)yj3d_private_setHostVC:(UIViewController *)hostVC {
    [YJ3DTouchUtil setAssociatedObject:hostVC withKey:@selector(yj3d_private_hostVC) policy:OBJC_ASSOCIATION_ASSIGN forTarget:self];
}

- (BOOL)yj3d_private_activePresent3DTouch {
    return [[YJ3DTouchUtil associatedObjectWithkey:_cmd forTarget:self] boolValue];
}

- (void)yj3d_private_setActivePresent3DTouch:(BOOL)active {
    [YJ3DTouchUtil setAssociatedObject:@(active) withKey:@selector(yj3d_private_activePresent3DTouch) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC forTarget:self];
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
    
    // Handle the problem of pushing the same viewController repeatedly
    if (viewController.yj_3DTouchStatus != YJ3DTouchStatus_None
        && viewController.yj_3DTouchStatus != YJ3DTouchStatus_Poped) {
        return;
    }
    
    [self yj3d_private_pushViewController:viewController animated:animated];
}

- (BOOL)yj3d_private_activePush3DTouch {
    return [[YJ3DTouchUtil associatedObjectWithkey:_cmd forTarget:self] boolValue];
}

- (void)yj3d_private_setActivePush3DTouch:(BOOL)active {
    [YJ3DTouchUtil setAssociatedObject:@(active) withKey:@selector(yj3d_private_activePush3DTouch) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC forTarget:self];
}

@end

#pragma mark - YJ3DTouch_View
@interface UIView (YJ3DTouch_View)
@end

@implementation UIView (YJ3DTouch_View)

- (UIViewController<UIViewControllerPreviewingDelegate> *)yj3d_private_previewDelegateController {
    return [YJ3DTouchUtil associatedObjectWithkey:_cmd forTarget:self];
}

- (void)yj3d_private_setPreviewDelegateController:(UIViewController *)viewController {
    [YJ3DTouchUtil setAssociatedObject:viewController withKey:@selector(yj3d_private_previewDelegateController) policy:OBJC_ASSOCIATION_ASSIGN forTarget:self];
}

- (YJ3DTouchConfig *)yj3d_private_3DTouchConfig {
    return [YJ3DTouchUtil associatedObjectWithkey:_cmd forTarget:self];
}

- (void)yj3d_private_set3DTouchConfig:(YJ3DTouchConfig *)config {
    [YJ3DTouchUtil setAssociatedObject:config withKey:@selector(yj3d_private_3DTouchConfig) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC forTarget:self];
}

- (BOOL)yj3d_private_hasRegistered3DTouch {
    return [[YJ3DTouchUtil associatedObjectWithkey:_cmd forTarget:self] boolValue];
}

- (void)yj3d_private_setHasRegistered3DTouch:(BOOL)registered {
    [YJ3DTouchUtil setAssociatedObject:@(registered) withKey:@selector(yj3d_private_hasRegistered3DTouch) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC forTarget:self];
}

@end

#pragma mark - YJ3DTouch_Cell
@interface UITableViewCell (YJ3DTouch_Cell)
@end

@implementation UITableViewCell (YJ3DTouch_Cell)

- (UITableView *)yj3d_private_cell_tableView {
    return [YJ3DTouchUtil associatedObjectWithkey:_cmd forTarget:self];
}

- (void)yj3d_private_cell_setTableView:(UITableView *)tableView {
    [YJ3DTouchUtil setAssociatedObject:tableView withKey:@selector(yj3d_private_cell_tableView) policy:OBJC_ASSOCIATION_ASSIGN forTarget:self];
}

@end

#pragma mark - YJ3DTouch_CollectionViewCell
@interface UICollectionViewCell (YJ3DTouch_CollectionViewCell)
@end

@implementation UICollectionViewCell (YJ3DTouch_CollectionViewCell)

- (UICollectionView *)yj3d_private_cell_CollectionView {
    return [YJ3DTouchUtil associatedObjectWithkey:_cmd forTarget:self];
}

- (void)yj3d_private_cell_setCollectionView:(UICollectionView *)collectionView {
    [YJ3DTouchUtil setAssociatedObject:collectionView withKey:@selector(yj3d_private_cell_CollectionView) policy:OBJC_ASSOCIATION_ASSIGN forTarget:self];
}

@end

static BOOL kYJ3DTouch_VC_Prepared = NO;
NSString * const YJ3DTouchActionNotification = @"YJ3DTouchActionNotification";
NSString * const YJ3DTouchActionUserInfoPageKey = @"actionPage";
NSString * const YJ3DTouchActionUserInfoStatusKey = @"actionStatus";

#pragma mark - UIViewController YJ3DTouch
@implementation UIViewController (YJ3DTouch)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidLoad)),
                                   class_getInstanceMethod(self, @selector(yj3d_private_viewDidLoad)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewWillAppear:)),
                                   class_getInstanceMethod(self, @selector(yj3d_private_viewWillAppear:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidAppear:)),
                                   class_getInstanceMethod(self, @selector(yj3d_private_viewDidAppear:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewWillDisappear:)),
                                   class_getInstanceMethod(self, @selector(yj3d_private_viewWillDisappear:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidDisappear:)),
                                   class_getInstanceMethod(self, @selector(yj3d_private_viewDidDisappear:)));
}

#pragma mark - Getter & Setter
- (YJ3DTouchStatus)yj_3DTouchStatus {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (void)setYj_3DTouchStatus:(YJ3DTouchStatus)yj_3DTouchStatus {
    objc_setAssociatedObject(self, @selector(yj_3DTouchStatus), @(yj_3DTouchStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YJ3DTouchTriggerBlock)yj_3DTouchTriggerBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYj_3DTouchTriggerBlock:(YJ3DTouchTriggerBlock)yj_3DTouchTriggerBlock {
    objc_setAssociatedObject(self, @selector(yj_3DTouchTriggerBlock), yj_3DTouchTriggerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (YJ3DViewControllerAppear)yj_appearStatus {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (void)setYj_appearStatus:(YJ3DViewControllerAppear)yj_appearStatus {
    objc_setAssociatedObject(self, @selector(yj_appearStatus), @(yj_appearStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YJ3DTouchActionStatus)yj_3DTouchActionStatus {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (void)setYj_3DTouchActionStatus:(YJ3DTouchActionStatus)yj_3DTouchActionStatus {
    objc_setAssociatedObject(self, @selector(yj_3DTouchActionStatus), @(yj_3DTouchActionStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIViewController *hostVC = self;
    
    switch (yj_3DTouchActionStatus) {
        case YJ3DTouchActionStatus_WillPeek:
        case YJ3DTouchActionStatus_DidPeek:
        case YJ3DTouchActionStatus_WillPop:
        case YJ3DTouchActionStatus_DidPop:
        case YJ3DTouchActionStatus_Cancel: {
            BOOL canContinue = YES;
            if (hostVC.yj_3DTouchTriggerBlock) {
                canContinue = hostVC.yj_3DTouchTriggerBlock(yj_3DTouchActionStatus, hostVC.yj3d_private_currentPreviewingView);
            }
            [hostVC yj3d_private_update3DTouchActionCanContinue:canContinue];
        }
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YJ3DTouchActionNotification
                                                        object:nil
                                                      userInfo:@{YJ3DTouchActionUserInfoPageKey: self,
                                                                 YJ3DTouchActionUserInfoStatusKey: @(yj_3DTouchActionStatus)}];
}

#pragma mark - Public
- (void)yj_active3DTouchTable:(UITableView *)tableView forNavigation:(UINavigationController *)navigation
{
    [self yj_active3DTouchView:tableView
                   clickTarget:nil
                   clickAction:nil
                      argument:nil
                 forNavigation:navigation];
}

- (void)yj_active3DTouchCollectionView:(UICollectionView *)collectionView forNavigation:(UINavigationController *)navigation
{
    [self yj_active3DTouchView:collectionView
                   clickTarget:nil
                   clickAction:nil
                      argument:nil
                 forNavigation:navigation];
}

- (void)yj_active3DTouchView:(UIView *)view
                 clickTarget:(NSObject *)target
                 clickAction:(SEL)action
                    argument:(id)argument
               forNavigation:(UINavigationController *)navigation
{
    if ([self yj3d_private_support3DTouch] == NO || view == nil || navigation == nil) {
        return;
    }
    
    if (target && action && [target respondsToSelector:action] == NO) {
        return;
    }
    
    YJ3DTouchConfig *config = [self yj3d_private_3DTouchConfigForPreviewSourceView:view extractDetailVC:NO];
    if (config == nil) {
        config = [YJ3DTouchConfig new];
    }
    
    config.navigation = navigation;
    config.clickActionTarget = target;
    config.clickAction = action;
    config.argument = argument;
    
    [self yj_active3DTouchView:view touchConfig:config];
}

- (void)yj_active3DTouchView:(UIView *)view touchConfig:(YJ3DTouchConfig *)touchConfig {
    if ([self yj3d_private_support3DTouch] == NO) {
        return;
    }
    
    if ([self yj3d_private_checkValidWithView:view touchConfig:touchConfig] == NO) {
        return;
    }
    
    [view yj3d_private_set3DTouchConfig:touchConfig];

    if ([view yj3d_private_hasRegistered3DTouch]) {
        return;
    }
    
    [view yj3d_private_setPreviewDelegateController:self];
    
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
        [self yj3d_private_active3DTouchForTableView:(UITableView *)view];
    } else if ([view isKindOfClass:[UICollectionView class]]) {
        [self yj3d_private_active3DTouchForCollectionView:(UICollectionView *)view];
    } else {
        [self registerForPreviewingWithDelegate:self sourceView:view];
    }
    
    [view yj3d_private_setHasRegistered3DTouch:YES];
}

// previewController will call this method, eg: detailVC
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIViewController *detailVC = self;
    UIViewController *hostVC = [detailVC yj3d_private_hostVC];
    if (hostVC == nil) {
        return nil;
    }
    
    UIView *currentPreviewingView = [hostVC yj3d_private_currentPreviewingView];
    YJ3DTouchConfig *config = [hostVC yj3d_private_3DTouchConfigForPreviewSourceView:currentPreviewingView extractDetailVC:NO];
    
    return config.previewActionItems;
}

#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext
              viewControllerForLocation:(CGPoint)location
{
    UIView *sourceView = [previewingContext sourceView];
    [self yj3d_private_setCurrentPreviewingView:sourceView];
    
    // trigger will peek
    self.yj_3DTouchActionStatus = YJ3DTouchActionStatus_WillPeek;
    if ([self yj3d_private_3DTouchActionCanContinue] == NO) {
        self.yj_3DTouchActionStatus = YJ3DTouchActionStatus_Cancel;
        return nil;
    }
    
    kYJ3DTouch_VC_Prepared = YES;
    YJ3DTouchConfig *config = [self yj3d_private_3DTouchConfigForPreviewSourceView:sourceView extractDetailVC:YES];
    kYJ3DTouch_VC_Prepared = NO;
    
    UIViewController *detailVC = [(config.navigation ?: config.presentingViewController) yj3d_private_detailVC];

    if (detailVC) {
        detailVC.yj_3DTouchStatus = YJ3DTouchStatus_Previewing;
        [detailVC yj3d_private_setHostVC:self];
    } else {
        self.yj_3DTouchActionStatus = YJ3DTouchActionStatus_Cancel;
    }
    
    if (config.navigation) {
        [config.navigation yj3d_private_setActivePush3DTouch:NO];
        [config.navigation yj3d_private_setDetailVC:nil];
    } else {
        [config.presentingViewController yj3d_private_setActivePresent3DTouch:NO];
        [config.presentingViewController yj3d_private_setDetailVC:nil];
    }
    
    return detailVC;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext
     commitViewController:(UIViewController *)viewControllerToCommit
{
    [self yj3d_private_cancelDelaySetCancelActionStatus];
    
    viewControllerToCommit.yj_3DTouchStatus = YJ3DTouchStatus_None;
    
    UIView *sourceView = [previewingContext sourceView];
    
    // trigger will pop
    self.yj_3DTouchActionStatus = YJ3DTouchActionStatus_WillPop;
    if ([self yj3d_private_3DTouchActionCanContinue] == NO) {
        self.yj_3DTouchActionStatus = YJ3DTouchActionStatus_Cancel;
        return;
    }
    
    self.yj_3DTouchActionStatus = YJ3DTouchActionStatus_DidPop;
    viewControllerToCommit.yj_3DTouchStatus = YJ3DTouchStatus_Poped;

    YJ3DTouchConfig *config = [self yj3d_private_3DTouchConfigForPreviewSourceView:sourceView extractDetailVC:NO];

    if (config.navigation) {
        [config.navigation pushViewController:viewControllerToCommit animated:YES];
    } else {
        [config.presentingViewController presentViewController:viewControllerToCommit animated:YES completion:nil];
    }
}

#pragma mark - Private
- (BOOL)yj3d_private_checkValidWithView:(UIView *)view touchConfig:(YJ3DTouchConfig *)touchConfig {
    if (view == nil) {
        return NO;
    }
    
    if (touchConfig.navigation == nil && touchConfig.presentingViewController == nil) {
        return NO;
    }
    
    if ([view isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)view;
        BOOL valid = [tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)];
        return valid;
    }
    
    if ([view isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)view;
        BOOL valid = [collectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)];
        return valid;
    }
    
    BOOL valid = (touchConfig.clickActionTarget && touchConfig.clickAction &&
                  [touchConfig.clickActionTarget respondsToSelector:touchConfig.clickAction]);
    return valid;
}

- (BOOL)yj3d_private_support3DTouch {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow respondsToSelector:@selector(traitCollection)]
        && [keyWindow.traitCollection respondsToSelector:@selector(forceTouchCapability)])
    {
        return keyWindow.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    
    return NO;
}

- (BOOL)yj3d_private_3DTouchActionCanContinue {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)yj3d_private_update3DTouchActionCanContinue:(BOOL)canContinue {
    objc_setAssociatedObject(self, @selector(yj3d_private_3DTouchActionCanContinue), @(canContinue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)yj3d_private_currentPreviewingView {
    return [YJ3DTouchUtil associatedObjectWithkey:_cmd forTarget:self];
}

- (void)yj3d_private_setCurrentPreviewingView:(UIView *)view {
    [YJ3DTouchUtil setAssociatedObject:view withKey:@selector(yj3d_private_currentPreviewingView) policy:OBJC_ASSOCIATION_ASSIGN forTarget:self];
}

- (YJ3DTouchConfig *)yj3d_private_3DTouchConfigForPreviewSourceView:(UIView *)sourceView
                                                    extractDetailVC:(BOOL)extract {
    YJ3DTouchConfig *config = [sourceView yj3d_private_3DTouchConfig];
    
    UIView *listView = nil;
    UIView *listCell = nil;
    
    if ([sourceView isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)sourceView;
        UITableView *tableView = [cell yj3d_private_cell_tableView];
        if (tableView) {
            config = [tableView yj3d_private_3DTouchConfig];
            
            listView = tableView;
            listCell = cell;
        }
    } else if ([sourceView isKindOfClass:[UICollectionViewCell class]]) {
        UICollectionViewCell *cell = (UICollectionViewCell *)sourceView;
        UICollectionView *collectionView = [cell yj3d_private_cell_CollectionView];
        if (collectionView) {
            config = [collectionView yj3d_private_3DTouchConfig];
            
            listView = collectionView;
            listCell = cell;
            
            BOOL notSupportSelect = [collectionView.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)] && ([collectionView.delegate collectionView:collectionView shouldSelectItemAtIndexPath:[collectionView indexPathForCell:cell]] == NO);
            if ([collectionView.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)] && notSupportSelect) {
                config = nil;
                listView = nil;
                listCell = nil;
                extract = NO;
            }
        }
    }
    
    if (extract) {
        if (config.navigation) {
            [config.navigation yj3d_private_setActivePush3DTouch:YES];
        } else {
            [config.presentingViewController yj3d_private_setActivePresent3DTouch:YES];
        }
        
        if ([listView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)listView;
            [tableView.delegate tableView:tableView
                  didSelectRowAtIndexPath:[tableView indexPathForCell:(UITableViewCell *)listCell]];
        } else if ([listView isKindOfClass:[UICollectionView class]]) {
            UICollectionView *collectionView = (UICollectionView *)listView;
            
            BOOL notSupportSelect = [collectionView.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)] && ([collectionView.delegate collectionView:collectionView shouldSelectItemAtIndexPath:[collectionView indexPathForCell:(UICollectionViewCell *)listCell]] == NO);
            BOOL canResponds = [collectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)];
            
            if (!notSupportSelect && canResponds) {
                [collectionView.delegate collectionView:collectionView didSelectItemAtIndexPath:[collectionView indexPathForCell:(UICollectionViewCell *)listCell]];
            }
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [config.clickActionTarget performSelector:config.clickAction withObject:config.argument];
#pragma clang diagnostic pop
        }
    }
    
    return config;
}

- (void)yj3d_private_viewDidLoad {
    if (kYJ3DTouch_VC_Prepared) {
        self.yj_3DTouchStatus = YJ3DTouchStatus_Prepared;
    }
    
    [self yj3d_private_viewDidLoad];
}

- (void)yj3d_private_viewWillAppear:(BOOL)animated {
    [self yj3d_private_viewWillAppear:animated];
    self.yj_appearStatus = YJ3DViewControllerAppear_WillAppear;
}

- (void)yj3d_private_viewDidAppear:(BOOL)animated {
    [self yj3d_private_viewDidAppear:animated];
    self.yj_appearStatus = YJ3DViewControllerAppear_DidAppear;
    
    UIViewController *hostVC = [self yj3d_private_hostVC];
    if (hostVC == nil) {
        return;
    }
    
    if (self.yj_3DTouchStatus == YJ3DTouchStatus_Previewing) {
        hostVC.yj_3DTouchActionStatus = YJ3DTouchActionStatus_DidPeek;
    }
}

- (void)yj3d_private_viewWillDisappear:(BOOL)animated {
    [self yj3d_private_viewWillDisappear:animated];
    self.yj_appearStatus = YJ3DViewControllerAppear_WillDisappear;
}

- (void)yj3d_private_viewDidDisappear:(BOOL)animated {
    [self yj3d_private_viewDidDisappear:animated];
    self.yj_appearStatus = YJ3DViewControllerAppear_DidDisappear;
    
    UIViewController *hostVC = [self yj3d_private_hostVC];
    if (hostVC == nil) {
        return;
    }
    
    if (self.yj_3DTouchStatus == YJ3DTouchStatus_Previewing) {
        [hostVC performSelector:@selector(yj3d_private_delaySetCancelActionStatus) withObject:nil afterDelay:0.2];
    }
    
    self.yj_3DTouchStatus = YJ3DTouchStatus_None;
}

- (void)yj3d_private_delaySetCancelActionStatus {
    self.yj_3DTouchActionStatus = YJ3DTouchActionStatus_Cancel;
}

- (void)yj3d_private_cancelDelaySetCancelActionStatus {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(yj3d_private_delaySetCancelActionStatus) object:nil];
}

- (void)yj3d_private_active3DTouchForTableView:(UITableView *)tableView {
    [YJ3DTouchUtil hookTableViewDataSource:tableView.dataSource withBlock:^(UITableViewCell *cell, UITableView *tableView) {
        if ([cell yj3d_private_hasRegistered3DTouch]) {
            return;
        }
        
        UIViewController *vc = [tableView yj3d_private_previewDelegateController];
        if (vc) {
            [cell yj3d_private_setHasRegistered3DTouch:YES];
            [cell yj3d_private_cell_setTableView:tableView];
            [vc registerForPreviewingWithDelegate:vc sourceView:cell];
        }
    }];
    
    for (UITableViewCell *cell in tableView.visibleCells) {
        if ([cell yj3d_private_hasRegistered3DTouch]) {
            continue;
        }
        
        [cell yj3d_private_setHasRegistered3DTouch:YES];
        UIViewController *vc = [tableView yj3d_private_previewDelegateController];
        [vc registerForPreviewingWithDelegate:vc sourceView:cell];
        [cell yj3d_private_cell_setTableView:tableView];
    }
}

- (void)yj3d_private_active3DTouchForCollectionView:(UICollectionView *)collectionView {
    [YJ3DTouchUtil hookCollectionViewDataSource:collectionView.dataSource withBlock:^(UICollectionViewCell *cell, UICollectionView *collectionView) {
        if ([cell yj3d_private_hasRegistered3DTouch]) {
            return;
        }
        
        UIViewController *vc = [collectionView yj3d_private_previewDelegateController];
        if (vc) {
            [vc registerForPreviewingWithDelegate:vc sourceView:cell];
            [cell yj3d_private_setHasRegistered3DTouch:YES];
            [cell yj3d_private_cell_setCollectionView:collectionView];
        }
    }];
    
    for (UICollectionViewCell *cell in collectionView.visibleCells) {
        if ([cell yj3d_private_hasRegistered3DTouch]) {
            continue;
        }
        
        [cell yj3d_private_setHasRegistered3DTouch:YES];
        UIViewController *vc = [collectionView yj3d_private_previewDelegateController];
        [vc registerForPreviewingWithDelegate:vc sourceView:cell];
        [cell yj3d_private_cell_setCollectionView:collectionView];
    }
}

@end
