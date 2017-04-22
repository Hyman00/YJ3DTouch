//
//  UIViewController+YJ3DTouch.h
//  YJ3DTouch
//
//  Created by hyman on 2017/3/31.
//  Copyright © 2017年 hyman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJ3DTouchConfig.h"

typedef NS_ENUM(NSUInteger, YJ3DViewControllerAppear) {
    YJ3DViewControllerAppear_None = 0,
    YJ3DViewControllerAppear_WillAppear,
    YJ3DViewControllerAppear_DidAppear,
    YJ3DViewControllerAppear_WillDisappear,
    YJ3DViewControllerAppear_DidDisappear
};

typedef NS_ENUM(NSUInteger, YJ3DTouchStatus) {
    YJ3DTouchStatus_None = 0,
    YJ3DTouchStatus_Prepared,
    YJ3DTouchStatus_Previewing,
    YJ3DTouchStatus_Poped
};

typedef NS_ENUM(NSUInteger, YJ3DTouchActionStatus) {
    YJ3DTouchActionStatus_None = 0,
    YJ3DTouchActionStatus_WillPeek,
    YJ3DTouchActionStatus_DidPeek,
    YJ3DTouchActionStatus_WillPop,
    YJ3DTouchActionStatus_DidPop,
    YJ3DTouchActionStatus_Cancel
};

/**
 *  @brief  It will be called when the sourceView will peek or pop.
 *  If the block return NO, then the 3D Touch will lose efficacy. 
    (It only takes effect when status is YJ3DTouchStatus_WillPeek and YJ3DTouchStatus_WillPop)
 *
 *  @param sourceView   A source view, in a previewing view controller’s view hierarchy, responds to a forceful touch by the use
 */
typedef BOOL(^YJ3DTouchTriggerBlock) (YJ3DTouchActionStatus status, UIView *sourceView);


@interface UIViewController (YJ3DTouch) <UIViewControllerPreviewingDelegate>

@property (nonatomic, assign, readonly) YJ3DViewControllerAppear yj_appearStatus;

@property (nonatomic, assign, readonly) YJ3DTouchStatus yj_3DTouchStatus;

@property (nonatomic, assign, readonly) YJ3DTouchActionStatus yj_3DTouchActionStatus;
@property (nonatomic, copy) YJ3DTouchTriggerBlock yj_3DTouchTriggerBlock;

/**
 *  @brief  active 3D Touch for UITableView
 *
 *  The method will automatic register 3D Touch for each cell.
 *
 *  @note
 *  Need to implement the tableView: didSelectRowAtIndexPath: method for the UITableViewDelegate
 *
 */
- (void)yj_active3DTouchTable:(UITableView *)tableView forNavigation:(UINavigationController *)navigation;

/**
 *  @brief  active 3D Touch for UICollectionView
 *
 *  The method will automatic register 3D Touch for each cell.
 *
 *  @note 
 *  1, Need to implement the collectionView: didSelectItemAtIndexPath: for the UICollectionViewDelegate
 *
 *  2, If the collectionView: shouldSelectItemAtIndexPath: method for the UICollectionViewDelegate return NO, at the indexPath of cell will not be registered 3D Touch;
 *
 */
- (void)yj_active3DTouchCollectionView:(UICollectionView *)collectionView forNavigation:(UINavigationController *)navigation;

/**
 *  @brief  active 3D Touch for view
 *
 *  @param target     the responder of the click
 *  @param action     the action of the click
 *  @param argument   an object that is the sole argument of the action
 *
 *  @note
 *  If the view is UITableView or UICollectionView, the method will ignore target, action, argument
 */
- (void)yj_active3DTouchView:(UIView *)view
                 clickTarget:(NSObject *)target
                 clickAction:(SEL)action
                    argument:(id)argument
               forNavigation:(UINavigationController *)navigation;

- (void)yj_active3DTouchView:(UIView *)view touchConfig:(YJ3DTouchConfig *)touchConfig;

@end
