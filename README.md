# YJ3DTouch
Adapt very easily to 3D Touch.

![image](https://github.com/Hyman00/YJ3DTouch/blob/master/tip.gif)

## How to use

```ObjC
[self yj_active3DTouchTable:self.tableView forNavigation:self.navigationController];
```
```ObjC
[self yj_active3DTouchControl:self.pushButton 
                       target:self 
                       action:@selector(pushButtonTap) 
                forNavigation:self.navigationController];
```
```ObjC
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
```
