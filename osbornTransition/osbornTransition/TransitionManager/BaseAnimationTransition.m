//
//  BaseAnimationTransition.m
//  osbornTransition
//
//  Created by zfan on 2017/8/26.
//  Copyright © 2017年 zfan. All rights reserved.
//

#import "BaseAnimationTransition.h"

static CGFloat const kChildViewPadding = 16;
static CGFloat const kDamping = 0.75f;
static CGFloat const kInitialSpringVelocity = 0.5f;


@interface BaseAnimationTransition ()<CAAnimationDelegate>
{
    TransitionType _transitionType;
    UIColor *_transitionColor;
    CGRect  _transitionSize;
}

/*DynamicAnimator*/
@property (strong, nonatomic) UIDynamicAnimator *animator;

/*Interactive*/

@end

@implementation BaseAnimationTransition

- (instancetype)initWithType:(TransitionType)type startSize:(CGRect)size color:(UIColor *)color {
    self = [super init];
    if (self) {
        _transitionType  = type;
        _transitionSize  = size;
        _transitionColor = color;
    }
    return self;
}

#pragma mark -- private Methods

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
//objc(1)
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
    
    
//objc(2)
    // When sliding the views horizontally, in and out, figure out whether we are going left or right.
    BOOL goingRight = ([transitionContext initialFrameForViewController:toViewController].origin.x < [transitionContext finalFrameForViewController:toViewController].origin.x);
    
    CGFloat travelDistance = [transitionContext containerView].bounds.size.width + kChildViewPadding;
    CGAffineTransform travel = CGAffineTransformMakeTranslation (goingRight ? travelDistance : -travelDistance, 0);
    
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    toViewController.view.transform = CGAffineTransformInvert (travel);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:kDamping initialSpringVelocity:kInitialSpringVelocity options:0x00 animations:^{
        fromViewController.view.transform = travel;
        fromViewController.view.alpha = 0;
        toViewController.view.transform = CGAffineTransformIdentity;
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
    
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
}


#pragma mark -- UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    switch (_transitionType) {
        case TransitionTypePush:
            [self presentAnimation:transitionContext];
            break;
            
        case TransitionTypePop:
            [self dismissAnimation:transitionContext];
            break;
    }
}


#pragma mark -- UIViewControllerInteractiveTransitioning 

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    
}


#pragma mark -- CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
}





@end
