//
//  YJ3DTouchConfig.h
//  YJ3DTouch
//
//  Created by hyman on 2017/3/31.
//  Copyright © 2017年 hyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YJ3DTouchConfig : NSObject

/// Priority in using the navigation
@property(nonatomic, weak) UINavigationController *navigation;
@property(nonatomic, weak) UIViewController *presentingViewController;

/// In addition to the UITableView, need to specify the responder
@property(nonatomic, weak) NSObject *customActionTarget;
@property(nonatomic, assign) SEL customAction;

@property(nonatomic, strong) NSArray <id <UIPreviewActionItem>> *previewActionItems;

@end
