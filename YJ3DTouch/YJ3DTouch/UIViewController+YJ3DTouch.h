//
//  UIViewController+YJ3DTouch.h
//  YJ3DTouch
//
//  Created by hyman on 2017/3/31.
//  Copyright © 2017年 hyman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJ3DTouchConfig.h"

@interface UIViewController (YJ3DTouch) <UIViewControllerPreviewingDelegate>

@property (nonatomic, assign, readonly) BOOL yj_previewing3DTouch;

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
