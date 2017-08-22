//
//  TransitionSegue.m
//  osbornTransition
//
//  Created by zfan on 2017/8/22.
//  Copyright © 2017年 zfan. All rights reserved.
//

#import "TransitionSegue.h"
#import "ViewController.h"
#import "CustomerViewController.h"

#define ScreenSize            [[UIScreen mainScreen] bounds].size
#define ScreenWidth           [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight          [[UIScreen mainScreen] bounds].size.height


@interface TransitionSegue() <CAAnimationDelegate>

@property (strong, nonatomic) ViewController   *fromVC;
@property (strong, nonatomic) CustomerViewController *toVC;

@property (strong, nonatomic) UIView      *circleView;
@property (strong, nonatomic) UIImageView *iconView;

@end


@implementation TransitionSegue

- (void)perform {
    self.fromVC = self.sourceViewController;
    self.toVC   = self.destinationViewController;
    
    if (_scrollToCamera) {
        
        self.circleView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.circleView.backgroundColor = self.buttonColor;
        [self.toVC.view addSubview:self.circleView];
        
        [self.fromVC.navigationController pushViewController:self.toVC animated:NO];
        [self hiddenCircleAnimation];
        
    }else {
        
        // 隐藏原来的按钮
        self.homeButton.hidden = YES;
        
        // 创建圆形
        self.circleView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.circleView.backgroundColor = self.buttonColor;
        
        // 创建图标
        self.iconView = [[UIImageView alloc] initWithFrame:self.buttonFrameOnScreen];
        self.iconView.image = [UIImage imageNamed:self.buttonImageName];
        self.iconView.layer.frame = self.buttonFrameOnScreen;
        
        CGFloat radius = sqrt(pow(ScreenWidth, 2) + pow(ScreenHeight, 2));
        CGRect fullRect = CGRectInset([[UIScreen mainScreen] bounds], ScreenWidth/2 - floor(radius), ScreenHeight/2 - floor(radius));
        UIBezierPath *startCycle = [UIBezierPath bezierPathWithOvalInRect:self.buttonFrameOnScreen];
        UIBezierPath *endCycle = [UIBezierPath bezierPathWithOvalInRect:fullRect];
        
        // 创建一个 CAShapeLayer 来负责展示圆形遮盖
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = endCycle.CGPath; // 将它的 path 指定为最终的 path 来避免在动画完成后会回弹
        self.circleView.layer.mask = maskLayer;
        
        // 添加到视图
        [self.fromVC.view addSubview:self.circleView];
        [self.fromVC.view addSubview:self.iconView];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.fromValue = (__bridge id)([startCycle CGPath]);
        animation.toValue = (__bridge id)([endCycle CGPath]);
        animation.duration =  0.2;
        animation.delegate = self;
        [maskLayer addAnimation:animation forKey:@"path"];
        
        CABasicAnimation *imageAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        imageAnimation.fromValue = [self.iconView.layer valueForKey:@"position"];
        imageAnimation.toValue   = [NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2, ScreenHeight/2)];
        imageAnimation.duration  =  0.2;
        self.iconView.layer.position = CGPointMake(ScreenWidth/2, ScreenHeight/2);
        [self.iconView.layer addAnimation:imageAnimation forKey:@"position"];
        
    }

}


#pragma mark  -- CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if ([[anim valueForKey:@"HiddenPath"] isEqualToString:@"circleBack"]) {
        [self.circleView removeFromSuperview];
    }else {
        [self.iconView   removeFromSuperview];
        [self.toVC.view addSubview:self.circleView];
        [self.fromVC.navigationController pushViewController:self.toVC animated:NO];
        [self hiddenCircleAnimation];
    }
}


- (void)hiddenCircleAnimation {
    
    CGFloat radius = sqrt(pow(ScreenWidth, 2) + pow(ScreenHeight, 2));
    CGRect fullRect = CGRectInset([[UIScreen mainScreen] bounds], ScreenWidth/2 - floor(radius), ScreenHeight/2 - floor(radius));
    CGRect rect = CGRectMake( ScreenWidth/2-15, ScreenHeight-ScreenHeight*(167.0/667.0)/2-15, 30, 30);
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithOvalInRect:rect];
    UIBezierPath *endCycle   = [UIBezierPath bezierPathWithOvalInRect:fullRect];
    //创建一个遮罩
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [startCycle CGPath];
    _circleView.layer.mask = maskLayer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id)([endCycle CGPath]);
    animation.toValue  = (__bridge id)([startCycle CGPath]);
    animation.duration =  0.2;
    animation.delegate = self;
    [animation setValue:@"circleBack" forKey:@"HiddenPath"];
    [maskLayer addAnimation:animation forKey:@"Path"];
    
}



@end
