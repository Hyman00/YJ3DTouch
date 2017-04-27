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
#import <objc/message.h>

UITableViewCell *impTableCellForItemAtIndexPath(id self, SEL selector, UITableView *tableView, NSIndexPath *indexPath);
UITableViewCell *impYj3dPrivateTableCellForItemAtIndexPath(id self, SEL selector, UITableView *tableView, NSIndexPath *indexPath);
UICollectionViewCell *impCollectionCellForItemAtIndexPath(id self, SEL selector, UICollectionView *cv, NSIndexPath *indexPath);
UICollectionViewCell *impYj3dPrivateCollectionCellForItemAtIndexPath(id self, SEL selector, UICollectionView *collectionView, NSIndexPath *indexPath);

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

- (UIViewController *)yj3d_private_hostVC {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)yj3d_private_setHostVC:(UIViewController *)hostVC {
    objc_setAssociatedObject(self, @selector(yj3d_private_hostVC), hostVC, OBJC_ASSOCIATION_ASSIGN);
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

#pragma mark - YJ3DTouch_CollectionViewCell
@interface UICollectionViewCell (YJ3DTouch_CollectionViewCell)
@end

@implementation UICollectionViewCell (YJ3DTouch_CollectionViewCell)

- (UICollectionView *)yj3d_private_cell_CollectionView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)yj3d_private_cell_setCollectionView:(UICollectionView *)collectionView {
    objc_setAssociatedObject(self, @selector(yj3d_private_cell_CollectionView), collectionView, OBJC_ASSOCIATION_ASSIGN);
}

@end

#pragma mark - YJ3DTouch_ListView_Delegate
@interface NSObject (YJ3DTouch_ListView_Delegate)
- (UITableViewCell *)yj3d_private_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewCell *)yj3d_private_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

static BOOL kYJ3DTouch_VC_Prepared = NO;

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
        UITableView *tableView = (UITableView *)view;
        [YJ3DTouchUtil dynamicProcessClass:[tableView.dataSource class]
                                    oriSel:@selector(tableView:cellForRowAtIndexPath:)
                                    altSel:@selector(yj3d_private_tableView:cellForRowAtIndexPath:)
                                    oriImp:(IMP)impTableCellForItemAtIndexPath
                                    altImp:(IMP)impYj3dPrivateTableCellForItemAtIndexPath];
    } else if ([view isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)view;
        [YJ3DTouchUtil dynamicProcessClass:[collectionView.dataSource class]
                                    oriSel:@selector(collectionView:cellForItemAtIndexPath:)
                                    altSel:@selector(yj3d_private_collectionView:cellForItemAtIndexPath:)
                                    oriImp:(IMP)impCollectionCellForItemAtIndexPath
                                    altImp:(IMP)impYj3dPrivateCollectionCellForItemAtIndexPath];
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
        return nil;
    }
    
    kYJ3DTouch_VC_Prepared = YES;
    YJ3DTouchConfig *config = [self yj3d_private_3DTouchConfigForPreviewSourceView:sourceView extractDetailVC:YES];
    kYJ3DTouch_VC_Prepared = NO;
    
    UIViewController *detailVC = [(config.navigation ?: config.presentingViewController) yj3d_private_detailVC];
    
    if (detailVC) {
        detailVC.yj_3DTouchStatus = YJ3DTouchStatus_Previewing;
        [detailVC yj3d_private_setHostVC:self];
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
    if ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    }
    
    return [UIApplication sharedApplication].keyWindow.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
}

- (BOOL)yj3d_private_3DTouchActionCanContinue {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)yj3d_private_update3DTouchActionCanContinue:(BOOL)canContinue {
    objc_setAssociatedObject(self, @selector(yj3d_private_3DTouchActionCanContinue), @(canContinue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)yj3d_private_currentPreviewingView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)yj3d_private_setCurrentPreviewingView:(UIView *)view {
    objc_setAssociatedObject(self, @selector(yj3d_private_currentPreviewingView), view, OBJC_ASSOCIATION_ASSIGN);
}

- (YJ3DTouchConfig *)yj3d_private_3DTouchConfigForPreviewSourceView:(UIView *)sourceView extractDetailVC:(BOOL)extract
{
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
            
            if ([collectionView.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)] &&
                [collectionView.delegate collectionView:collectionView shouldSelectItemAtIndexPath:[collectionView indexPathForCell:cell]] == NO)
            {
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
        
        if ([listView isKindOfClass:[UITableView class]])
        {
            UITableView *tableView = (UITableView *)listView;
            [tableView.delegate tableView:tableView didSelectRowAtIndexPath:[tableView indexPathForCell:(UITableViewCell *)listCell]];
        }
        else if ([listView isKindOfClass:[UICollectionView class]])
        {
            UICollectionView *collectionView = (UICollectionView *)listView;
            
            if ([collectionView.delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)] &&
                [collectionView.delegate collectionView:collectionView shouldSelectItemAtIndexPath:[collectionView indexPathForCell:(UICollectionViewCell *)listCell]])
            {
                [collectionView.delegate collectionView:collectionView didSelectItemAtIndexPath:[collectionView indexPathForCell:(UICollectionViewCell *)listCell]];
            }
        }
        else
        {
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

@end

#pragma mark - 实现函数

// TableView动态接口
void configTableViewCell(UITableView *tableView, UITableViewCell *cell)
{
    if ([cell yj3d_private_hasRegistered3DTouch] == NO) {
        [cell yj3d_private_setHasRegistered3DTouch:YES];
        
        UIViewController<UIViewControllerPreviewingDelegate> *vc = [tableView yj3d_private_previewDelegateController];
        [vc registerForPreviewingWithDelegate:vc sourceView:cell];
        
        [cell yj3d_private_cell_setTableView:tableView];
    }
}

UITableViewCell *impTableCellForItemAtIndexPath(id self, SEL selector, UITableView *tableView, NSIndexPath *indexPath)
{
    // 调用父类接口
    struct objc_super superTarget;
    superTarget.receiver = self;
    Class cls = object_getClass(self);
    superTarget.super_class = class_getSuperclass(cls);
    UITableViewCell *cell = objc_msgSendSuper(&superTarget, selector, tableView, indexPath);
    
    configTableViewCell(tableView, cell);
    
    return cell;
}

UITableViewCell *impYj3dPrivateTableCellForItemAtIndexPath(id self, SEL selector, UITableView *tableView, NSIndexPath *indexPath)
{
    UIViewController *pSelf = self;
    UITableViewCell *cell = [pSelf yj3d_private_tableView:tableView cellForRowAtIndexPath:indexPath];
    
    configTableViewCell(tableView, cell);
    
    return cell;
}

// CollectionView动态接口
void configCollectionViewCell(UICollectionView *collectionView, UICollectionViewCell *cell)
{
    if ([cell yj3d_private_hasRegistered3DTouch] == NO) {
        [cell yj3d_private_setHasRegistered3DTouch:YES];
        
        UIViewController<UIViewControllerPreviewingDelegate> *vc = [collectionView yj3d_private_previewDelegateController];
        [vc registerForPreviewingWithDelegate:vc sourceView:cell];
        
        [cell yj3d_private_cell_setCollectionView:collectionView];
    }
}

UICollectionViewCell *impCollectionCellForItemAtIndexPath(id self, SEL selector, UICollectionView *collectionView, NSIndexPath *indexPath)
{
    // 调用父类接口
    struct objc_super superTarget;
    superTarget.receiver = self;
    Class cls = object_getClass(self);
    superTarget.super_class = class_getSuperclass(cls);
    UICollectionViewCell *cell = objc_msgSendSuper(&superTarget, selector, collectionView, indexPath);
    
    configCollectionViewCell(collectionView, cell);
    
    return cell;
}

UICollectionViewCell *impYj3dPrivateCollectionCellForItemAtIndexPath(id self, SEL selector, UICollectionView *collectionView, NSIndexPath *indexPath)
{
    UIViewController *pSelf = self;
    UICollectionViewCell *cell = [pSelf yj3d_private_collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    configCollectionViewCell(collectionView, cell);
    
    return cell;
}
