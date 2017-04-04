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

/// Need to implement the tableView: didSelectRowAtIndexPath: method for the  tableView datasource
- (void)yj_active3DTouchTable:(UITableView *)tableView forNavigation:(UINavigationController *)navigation;
- (void)yj_active3DTouchControl:(UIControl *)control
                         target:(NSObject *)target
                         action:(SEL)action
                  forNavigation:(UINavigationController *)navigation;

- (void)yj_active3DTouchView:(UIView *)view touchConfig:(YJ3DTouchConfig *)touchConfig;

@end
