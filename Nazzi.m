//
//  Nazzi.h
//
//  Created by Adoma on 2018/1/23.
//  Copyright © 2018年 Adoma. All rights reserved.
//

#import "Nazzi.h"
#import <objc/runtime.h>

@interface ADContentController: UIViewController
@end

@implementation ADContentController

- (UINavigationController *)navigationController
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self.parentViewController;
    }
    return [super navigationController];
}

@end

@interface ADRealNavigationController: UINavigationController
@end

@implementation ADRealNavigationController

- (UINavigationController *)navigationController
{
    if ([self.parentViewController isKindOfClass:[ADContentController class]]) {
        return self.parentViewController.navigationController;
    }
    return nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count == 0) {
        [super pushViewController:viewController animated:animated];
        return;
    }
    [self.navigationController pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
   return [self.navigationController popViewControllerAnimated:animated];
}

@end

@implementation UINavigationController (Nazzi)

+ (void)load
{
    Method oriPush = class_getInstanceMethod([UINavigationController class], @selector(pushViewController:animated:));
    Method excPush = class_getInstanceMethod([UINavigationController class], @selector(ad_pushViewController:animated:));
    
    method_exchangeImplementations(oriPush, excPush);
}

- (void)ad_pushViewController:(UIViewController *)vc animated:(BOOL)animated
{
    if ([self isKindOfClass:[ADRealNavigationController class]]) {
        [self ad_pushViewController:vc animated:animated];
        return;
    }
    
    if (self.childViewControllers.count == 0) {
        self.navigationBar.hidden = YES;
    }
    
    UIViewController *content = [ADContentController new];
    UINavigationController *realNavi = [[ADRealNavigationController alloc] initWithRootViewController:vc];
    
    [content.view addSubview:realNavi.view];
    [content addChildViewController:realNavi];
    
    [self ad_pushViewController:content animated:animated];
}

@end
