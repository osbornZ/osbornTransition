//
//  ViewController.m
//  osbornTransition
//
//  Created by zfan on 2017/8/22.
//  Copyright © 2017年 zfan. All rights reserved.
//

#import "ViewController.h"

#import "TransitionSegue.h"

@interface ViewController ()<UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//StoryBoard unwind  action
- (IBAction)unwindToHome:(UIStoryboardSegue *)unwindSegue {
    //This is the Test for unwind

}


#pragma mark --UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    
    
    return nil;
}


#pragma mark --
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}








@end
