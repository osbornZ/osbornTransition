//
//  ViewController.m
//  osbornTransition
//
//  Created by zfan on 2017/8/22.
//  Copyright © 2017年 zfan. All rights reserved.
//

#import "ViewController.h"

#import "TransitionSegue.h"
#import "BaseAnimationTransition.h"

#import "LastViewController.h"
#import "CustomerViewController.h"

#define RGBA(r,g,b,a)     [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]
#define RGBAHEX(hex,a)    RGBA((float)((hex & 0xFF0000) >> 16),(float)((hex & 0xFF00) >> 8),(float)(hex & 0xFF),a)

#define  MainScreenSizeWidth    [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *lastVcBtn;
@property (strong, nonatomic) BaseAnimationTransition *transitionAnimator;

@property (nonatomic, strong) UIView *iconBackgroundView; //Test Animation

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addBackGroundView];
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

- (BaseAnimationTransition *)transitionAnimator {
    
    if (!_transitionAnimator) {
        CGRect startRect =  [self.view convertRect:_lastVcBtn.frame toView:self.view];
        BaseAnimationTransition *animator = [[BaseAnimationTransition alloc]initWithType:TransitionTypePush startSize:startRect color:[UIColor lightGrayColor]];
        _transitionAnimator = animator;
    }
    return _transitionAnimator;
}

- (IBAction)actionToLastVc:(id)sender {
    
    LastViewController *lastViewController = [[LastViewController alloc]initWithNibName:@"LastViewController" bundle:nil];
//    UIStoryboard *toVCStoryboard = [UIStoryboard storyboardWithName:@"StoryboardName" bundle:nil];
//    toVC = [toVCStoryboard instantiateViewControllerWithIdentifier:@"ViewControllerIdentifier"];
    
    TransitionSegue *pushSegue = [TransitionSegue segueWithIdentifier:@"HomeVCGrayLightBtn" source:self destination:lastViewController performHandler:^{
    }];
    [self prepareForSegue:pushSegue sender:nil];
    [pushSegue perform];
    
}

- (IBAction)actionCustomViewController:(id)sender {
    
    CustomerViewController *customerController = nil;
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    customerController = [main instantiateViewControllerWithIdentifier:@"CustomerViewController"];
    
    [self.navigationController pushViewController:customerController animated:YES];
}

//StoryBoard unwind  action
- (IBAction)unwindToHome:(UIStoryboardSegue *)unwindSegue {
    //This is the Test for unwind

}

#pragma mark --UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if ([toVC isKindOfClass:[CustomerViewController class]] ) {
        return self.transitionAnimator;
    }
    
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController*)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController {
    /*non interactive return nil*/
    return nil;
//    return self.interactionController;
}

#pragma mark --
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"HomeVCGrayLightBtn"]) {
        
        TransitionSegue *transition = (TransitionSegue *)segue;
        UIButton *button = (UIButton *)sender;
        transition.homeButton = button;
        CGRect startRect =  [self.view convertRect:_lastVcBtn.frame toView:self.view];
        transition.buttonFrameOnScreen = startRect;
        transition.buttonColor = [UIColor lightGrayColor];
        transition.fadeOut = YES;
        transition.scrollToCamera = NO;
    }

}



#pragma mark --  waveAnimation Test

- (void)addBackGroundView {
    
    _iconBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenSizeWidth/2.0-20, 4, 40, 40)];
    _iconBackgroundView.backgroundColor = RGBAHEX(0xFF4970, .9f);
    _iconBackgroundView.layer.cornerRadius = 20;
    _iconBackgroundView.alpha = 0.f;
    [self.view addSubview:_iconBackgroundView];
    
    [self waveAnimation];
}

- (void)waveAnimation {

    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath   = @"transform.scale";
    scale.fromValue = [NSNumber numberWithFloat:1.0];
    scale.toValue   = [NSNumber numberWithFloat:1.5];
    CABasicAnimation *scale1 = [CABasicAnimation animation];
    scale1.keyPath = @"opacity";
    scale1.fromValue =[NSNumber numberWithFloat:.5];
    scale1.toValue =[NSNumber numberWithFloat:0.0];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scale,scale1];
    group.duration = 1.2;
    group.repeatCount = 2;
    group.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *allgroup = [CAAnimationGroup animation];
    allgroup.duration  = 2.5;
    allgroup.animations  = @[group];
    allgroup.repeatCount = HUGE_VALF;
    allgroup.removedOnCompletion = NO;
    
    [self.iconBackgroundView.layer addAnimation:allgroup forKey:nil];

}




@end
