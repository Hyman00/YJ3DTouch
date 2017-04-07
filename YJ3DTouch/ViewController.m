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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIButton *pushButton;
@property (nonatomic, weak) IBOutlet UIButton *presentButton;
@property (nonatomic, weak) IBOutlet UIView *customView;
@property (nonatomic, weak) IBOutlet UIButton *actionItemsBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // pushButton
    [self.pushButton addTarget:self action:@selector(pushButtonTap) forControlEvents:UIControlEventTouchUpInside];
    
    [self yj_active3DTouchView:self.pushButton
                   clickTarget:self
                   clickAction:@selector(pushButtonTap)
                      argument:nil
                 forNavigation:self.navigationController];
    
    // presentButton
    [self.presentButton addTarget:self
                           action:@selector(presentButtonTap:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    YJ3DTouchConfig *presentConfig = [YJ3DTouchConfig new];
    presentConfig.clickActionTarget = self;
    presentConfig.clickAction = @selector(presentButtonTap:);
    presentConfig.argument = self.presentButton;
    presentConfig.presentingViewController = self.navigationController;
    [self yj_active3DTouchView:self.presentButton touchConfig:presentConfig];
    
    // customView
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customViewTap)];
    [self.customView addGestureRecognizer:tapG];
    
    YJ3DTouchConfig *customConfig = [YJ3DTouchConfig new];
    customConfig.navigation = self.navigationController;
    customConfig.clickActionTarget = self;
    customConfig.clickAction = @selector(customViewTap);
    [self yj_active3DTouchView:self.customView touchConfig:customConfig];

    
    // actionItemsBtn
    [self.actionItemsBtn addTarget:self action:@selector(actionItemsBtnTap) forControlEvents:UIControlEventTouchUpInside];
    YJ3DTouchConfig *actionItemConfig = [YJ3DTouchConfig new];
    actionItemConfig.navigation = self.navigationController;
    actionItemConfig.clickActionTarget = self;
    actionItemConfig.clickAction = @selector(actionItemsBtnTap);
    
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
    
    
    // tableView
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self yj_active3DTouchTable:self.tableView forNavigation:self.navigationController];
    
    
    // collectionView
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self yj_active3DTouchCollectionView:self.collectionView forNavigation:self.navigationController];
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

- (void)presentButtonTap:(UIButton *)btn {
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

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [self private_randomColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SecondViewController *vc = [SecondViewController new];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    vc.view.backgroundColor = cell.contentView.backgroundColor;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
- (UIColor *)private_randomColor {
    CGFloat hue = arc4random() % 100 / 100.0;
    CGFloat saturation = (arc4random() % 50 / 100) + 0.5;
    CGFloat brightness = (arc4random() % 50 / 100) + 0.5;
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
