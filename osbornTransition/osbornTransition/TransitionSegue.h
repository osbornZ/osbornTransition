//
//  TransitionSegue.h
//  osbornTransition
//
//  Created by zfan on 2017/8/22.
//  Copyright © 2017年 zfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitionSegue : UIStoryboardSegue


@property (assign, nonatomic) BOOL fadeOut;

@property (strong, nonatomic) UIColor *buttonColor;
@property (strong, nonatomic) NSString *buttonImageName;

@property (weak, nonatomic) UIView *homeButton;

@property (assign, nonatomic) CGRect buttonFrameOnScreen;
@property (assign, nonatomic) BOOL   scrollToCamera;


@end
