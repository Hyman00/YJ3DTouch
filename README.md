# YJ3DTouch
YJ3DTouch can easily implement 3D Touch.

<img src="https://github.com/Hyman00/YJ3DTouch/blob/master/tip.gif" width="320px" height="569px"/>

## How to use

#### First
```objective-c
#import "UIViewController+YJ3DTouch.h"
```

#### Active 3D Touch for UITableView

```objective-c
[self yj_active3DTouchTable:self.tableView forNavigation:self.navigationController];
```

> 1, The method will automatic register 3D Touch for each cell.
>
> 2, The table of delegate need implement the "tableView: didSelectRowAtIndexPath:"  method.


#### Active 3D Touch for UICollectionView

```objective-c
[self yj_active3DTouchCollectionView:self.collectionView forNavigation:self.navigationController];
```

> 1, The method will automatic register 3D Touch for each cell.
>
> 2, The collectionView of delegate need implement the "collectionView: didSelectItemAtIndexPath:" method.
>
> 3, If the collectionView: shouldSelectItemAtIndexPath: method for the UICollectionViewDelegate return NO, at the indexPath of cell will not be registered 3D Touch.


#### Active 3D Touch for UIView

```objective-c
[self yj_active3DTouchView:self.pushButton
               clickTarget:self
               clickAction:@selector(pushButtonTap)
                  argument:nil
             forNavigation:self.navigationController];
```

> 1, If the view is UITableView or UICollectionView, the method will ignore target, action, argument.
>
> 2, You can also use the method to active 3D Touch for UITableViewCell or UICollectionViewCell. However, you can no longer use the "yj_active3DTouchTable:forNavigation:" or "yj_active3DTouchCollectionView:forNavigation:" method.


#### Active 3D Touch with action

```objective-c
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
```

