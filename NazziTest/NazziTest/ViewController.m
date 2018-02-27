//
//  ViewController.m
//  NazziTest
//
//  Created by Adoma on 2018/2/22.
//  Copyright © 2018年 Adoma. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat r = (arc4random()%255) / 255.;
    CGFloat g = (arc4random()%255) / 255.;
    CGFloat b = (arc4random()%255) / 255.;
    
    self.view.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    self.title = [NSString stringWithFormat:@"%d",arc4random()%100];

}

- (IBAction)action
{
    
    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // self.navigationController is ADRealNavigationController
    
    //测试从viewControllers取出任意控制器并赋值
    ViewController *vc = self.navigationController.viewControllers[2];
    vc.label.text = @"adoma";
    
    //测试设置viewControllers和setViewControllers
//    NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:5];
//    for (int i = 0; i < 5; i ++) {
//        ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
//        [vcs addObject:vc];
//    }
//    self.navigationController.viewControllers = vcs;
    
//    [self.navigationController setViewControllers:vcs animated:YES];
}

@end
