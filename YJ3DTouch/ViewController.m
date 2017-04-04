//
//  ViewController.m
//  YJ3DTouch
//
//  Created by hyman on 2017/3/30.
//  Copyright © 2017年 hyman. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "UIViewController+YJ3DTouch.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *pushButton;
@property (nonatomic, weak) IBOutlet UIButton *presentButton;
@property (nonatomic, weak) IBOutlet UIView *customView;
@property (nonatomic, weak) IBOutlet UIButton *actionItemsBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.pushButton addTarget:self action:@selector(pushButtonTap) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self yj_active3DTouchTable:self.tableView forNavigation:self.navigationController];
    [self yj_active3DTouchControl:self.pushButton target:self action:@selector(pushButtonTap) forNavigation:self.navigationController];

    
    [self.presentButton addTarget:self action:@selector(presentButtonTap)
                 forControlEvents:UIControlEventTouchUpInside];
    
    YJ3DTouchConfig *presentConfig = [YJ3DTouchConfig new];
    presentConfig.customActionTarget = self;
    presentConfig.customAction = @selector(presentButtonTap);
    presentConfig.presentingViewController = self.navigationController;
    [self yj_active3DTouchView:self.presentButton touchConfig:presentConfig];
    
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customViewTap)];
    [self.customView addGestureRecognizer:tapG];
    
    YJ3DTouchConfig *customConfig = [YJ3DTouchConfig new];
    customConfig.navigation = self.navigationController;
    customConfig.customActionTarget = self;
    customConfig.customAction = @selector(customViewTap);
    [self yj_active3DTouchView:self.customView touchConfig:customConfig];

    
    
    [self.actionItemsBtn addTarget:self action:@selector(actionItemsBtnTap) forControlEvents:UIControlEventTouchUpInside];
    YJ3DTouchConfig *actionItemConfig = [YJ3DTouchConfig new];
    actionItemConfig.navigation = self.navigationController;
    actionItemConfig.customActionTarget = self;
    actionItemConfig.customAction = @selector(actionItemsBtnTap);
    
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"action1"
                                                          style:UIPreviewActionStyleDefault
                                                        handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                                                            NSLog(@"action1");
                                                        }];
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"action2"
                                                          style:UIPreviewActionStyleDefault
                                                        handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                                                            NSLog(@"action2");
                                                        }];
    actionItemConfig.previewActionItems = @[action1, action2];
    [self yj_active3DTouchView:self.actionItemsBtn touchConfig:actionItemConfig];
}

- (void)customViewTap {
    SecondViewController *vc = [SecondViewController new];
    vc.detail = @"customViewTap";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushButtonTap {
    SecondViewController *vc = [SecondViewController new];
    vc.detail = @"PushButton";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionItemsBtnTap {
    SecondViewController *vc = [SecondViewController new];
    vc.detail = @"actionItemsBtnTap";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentButtonTap {
    SecondViewController *vc = [SecondViewController new];
    vc.detail = @"presentButtonTap";
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"cell_%ld", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SecondViewController *vc = [SecondViewController new];
    vc.detail = cell.textLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
