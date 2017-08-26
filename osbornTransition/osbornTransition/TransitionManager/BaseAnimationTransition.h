//
//  BaseAnimationTransition.h
//  osbornTransition
//
//  Created by zfan on 2017/8/26.
//  Copyright © 2017年 zfan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,TransitionType) {
    /*** prepareForSegue*/
    TransitionTypePush = 0,
    /***  unwindForSegue*/
    TransitionTypePop
};

@interface BaseAnimationTransition : NSObject <
    UIViewControllerAnimatedTransitioning,
    UIViewControllerInteractiveTransitioning>

@property (nonatomic) BOOL interactive; //

- (instancetype)initWithType:(TransitionType)type
                   startSize:(CGRect)size
                       color:(UIColor *)color;


@end
