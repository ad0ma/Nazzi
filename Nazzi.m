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

@interface ADRealNavigationController: UINavigationController
@end

OS_ALWAYS_INLINE ADContentController *__packViewController(UIViewController *vc) {
    
    ADContentController *content = [ADContentController new];
    
    content.title = vc.title;
    content.tabBarItem = vc.tabBarItem;
    
    UINavigationController *realNavi = [[ADRealNavigationController alloc] initWithRootViewController:vc];
    
    [content.view addSubview:realNavi.view];
    [content addChildViewController:realNavi];
    
    return content;
}

@implementation ADContentController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (UINavigationController *)navigationController
{
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self.parentViewController;
    }
    return [super navigationController];
}

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
    
    Method oriInitWithCoder = class_getInstanceMethod([UINavigationController class], @selector(initWithCoder:));
    Method excInitWithCoder = class_getInstanceMethod([UINavigationController class], @selector(ad_initWithCoder:));
    
    method_exchangeImplementations(oriInitWithCoder, excInitWithCoder);
}

- (instancetype)ad_initWithCoder:(NSCoder *)aDecoder
{
    UINavigationController *ori = [self ad_initWithCoder:aDecoder];
    ori.viewControllers = @[__packViewController(ori.topViewController)];
    ori.navigationBar.hidden = YES;
    return ori;
}

- (void)ad_pushViewController:(UIViewController *)vc animated:(BOOL)animated
{
    if ([self isKindOfClass:[ADRealNavigationController class]]) {
        [self ad_pushViewController:vc animated:animated];
        return;
    }
    
    self.navigationBar.hidden = YES;
    [self ad_pushViewController:__packViewController(vc) animated:animated];
}

@end
