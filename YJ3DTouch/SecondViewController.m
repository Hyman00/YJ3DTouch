//
//  SecondViewController.m
//  YJ3DTouch
//
//  Created by hyman on 2017/4/1.
//  Copyright © 2017年 hyman. All rights reserved.
//

#import "SecondViewController.h"
#import "UIViewController+YJ3DTouch.h"

@interface SecondViewController ()
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.label.text = self.detail;
    
    [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.yj_previewing3DTouch) {
        self.closeButton.hidden = YES;
    } else {
        self.closeButton.hidden = self.presentingViewController == nil;
    }
}

- (void)setDetail:(NSString *)detail {
    _detail = [detail copy];
    self.label.text = _detail;
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
