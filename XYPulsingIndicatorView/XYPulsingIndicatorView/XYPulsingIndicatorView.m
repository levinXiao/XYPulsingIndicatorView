//
//  XYPulsingIndicatorView.m
//  XYPulsingIndicatorView
//
//  Created by xiaoyu on 16/5/20.
//  Copyright © 2016年 xiaoyu. All rights reserved.
//

#import "XYPulsingIndicatorView.h"

@implementation XYPulsingIndicatorView

static UIButton *windowWholeButton;

static UIView *contentView;

static UIView *indicatingView;
static UIImageView *finishingImageView;
static UILabel *textLabel;

static BOOL isShowing;

static BOOL canTouchToDismiss;

static void(^touchDismissBlock)();

+(void)show{
    if (isShowing) {
        return;
    }
    [self showWithText:@"请稍后..."];
}

+(void)showTouchableWithText:(NSString *)text{
    if (isShowing) {
        return;
    }
    canTouchToDismiss = NO;
    touchDismissBlock = nil;
    [self _insideShowWithText:text touchable:YES touchToDismissComplete:nil];
}

+(void)showWithText:(NSString *)text{
    if (isShowing) {
        return;
    }
    [self _insideShowWithText:text touchable:NO touchToDismissComplete:nil];
}

+(void)showWithText:(NSString *)text touchToDismissComplete:(void (^)())touchDimissComplete{
    [self _insideShowWithText:text touchable:YES touchToDismissComplete:touchDimissComplete];
}

+(void)_insideShowWithText:(NSString *)text touchable:(BOOL)touchable touchToDismissComplete:(void (^)())touchDimissComplete{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!windowWholeButton) {
        [windowWholeButton.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        windowWholeButton = [[UIButton alloc] init];
        windowWholeButton.frame = (CGRect){0,0,keyWindow.frame.size.width,keyWindow.frame.size.height};
        windowWholeButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [windowWholeButton addTarget:self action:@selector(windowWholeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        windowWholeButton.alpha = 0;
        
        contentView = [[UIView alloc] initWithFrame:(CGRect){
            (CGRectGetWidth(windowWholeButton.frame)-150)/2,
            (CGRectGetHeight(windowWholeButton.frame)-100)/2,
            150,
            100
        }];
        contentView.backgroundColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
        contentView.layer.cornerRadius = 10.f;
        contentView.layer.masksToBounds = YES;
        [windowWholeButton addSubview:contentView];
        
        float labelHeight = 20;
        float labelAliginHeight = 5;
        
        textLabel = [[UILabel alloc] init];
        textLabel.frame = (CGRect){
            10,
            CGRectGetHeight(contentView.frame)-labelHeight-labelAliginHeight,
            CGRectGetWidth(contentView.frame)-10*2,
            labelHeight
        };
        textLabel.textColor = [UIColor colorWithRed:118/255.f green:134/255.f blue:147/255.f alpha:1];
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:textLabel];
        
        indicatingView = [[UIView alloc] init];
        indicatingView.frame = (CGRect){
            (CGRectGetWidth(contentView.frame)-20)/2,
            (CGRectGetHeight(contentView.frame)-20-labelAliginHeight)/2-8,
            20,
            20
        };
        indicatingView.layer.cornerRadius = CGRectGetWidth(indicatingView.frame)/2;
        indicatingView.backgroundColor = [UIColor colorWithRed:26/255.f green:161/255.f blue:230/255.f alpha:1];
        [contentView addSubview:indicatingView];
        
        finishingImageView = [[UIImageView alloc] init];
        finishingImageView.frame = (CGRect){
            (CGRectGetWidth(contentView.frame)-32)/2,
            CGRectGetMidY(indicatingView.frame)-32/2,
            32,
            32
        };
        [contentView addSubview:finishingImageView];
        
        [self initPulsingLayer];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initPulsingLayer) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    
    if (touchable) {
        canTouchToDismiss = YES;
        if (touchDimissComplete) {
            touchDismissBlock = touchDimissComplete;
        }else{
            touchDismissBlock = nil;
        }
    }else{
        canTouchToDismiss = NO;
        touchDismissBlock = nil;
    }
    
    textLabel.text = text?text:@"请稍候";
    
    finishingImageView.alpha = 0;
    indicatingView.alpha = 0;
    
    for (CALayer *layer in indicatingView.layer.sublayers) {
        [layer XYPulsingIndicatorView_resume];
    }
    [UIView animateWithDuration:0.3 animations:^{
        windowWholeButton.alpha = 1;
        finishingImageView.alpha = 0;
        indicatingView.alpha = 1;
    }];
    
    isShowing = YES;
    [keyWindow addSubview:windowWholeButton];
    
}

+(void)success{
    [self successWithText:nil];
}

+(void)successWithText:(NSString *)successText{
    [self successWithText:nil dismissDuration:0];
}

+(void)successWithText:(NSString *)successText dismissDuration:(float)duration{
    [self successWithText:successText imageName:nil dismissDuration:duration];
}

+(void)successWithText:(NSString *)successText imageName:(NSString *)imageName dismissDuration:(float)duration{
    if (!imageName || [imageName isEqualToString:@""]) {
        [self successWithText:successText image:nil dismissDuration:duration];
        return;
    }
    [self successWithText:successText image:[UIImage imageNamed:imageName] dismissDuration:duration];
}

+(void)successWithText:(NSString *)successText image:(UIImage *)image dismissDuration:(float)duration{
    if (!successText) {
        successText = @"成功";
    }
    if (duration < 0.1f) {
        duration = 0.5f;
    }
    if (!image) {
        image = [UIImage imageNamed:@"XYPulsingIndicatorView_success"];
    }
    finishingImageView.image = image;
    textLabel.text = successText;
    [UIView animateWithDuration:0.3f animations:^{
        indicatingView.alpha = 0;
        finishingImageView.alpha = 1;
    }];
    canTouchToDismiss = YES;
    touchDismissBlock = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

+(void)fail{
    [self failWithText:nil];
}

+(void)failWithText:(NSString *)failText{
    [self failWithText:failText dismissDuration:0];
}

+(void)failWithText:(NSString *)failText dismissDuration:(float)duration{
    [self failWithText:failText imageName:nil dismissDuration:duration];
}

+(void)failWithText:(NSString *)failText imageName:(NSString *)imageName dismissDuration:(float)duration{
    if (!imageName || [imageName isEqualToString:@""]) {
        [self failWithText:failText image:nil dismissDuration:duration];
        return;
    }
    [self failWithText:failText image:[UIImage imageNamed:imageName] dismissDuration:duration];
}

+(void)failWithText:(NSString *)failText image:(UIImage *)image dismissDuration:(float)duration{
    if (!failText) {
        failText = @"失败";
    }
    if (duration < 0.1f) {
        duration = 0.5f;
    }
    if (!image) {
        image = [UIImage imageNamed:@"XYPulsingIndicatorView_failure"];
    }
    
    finishingImageView.image = image;
    textLabel.text = failText;
    [UIView animateWithDuration:0.3f animations:^{
        indicatingView.alpha = 0;
        finishingImageView.alpha = 1;
    }];
    canTouchToDismiss = YES;
    touchDismissBlock = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

+(void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        windowWholeButton.alpha = 0;
    }completion:^(BOOL finished) {
        for (CALayer *layer in indicatingView.layer.sublayers) {
            [layer XYPulsingIndicatorView_reset];
            [layer XYPulsingIndicatorView_pause];
        }
        [windowWholeButton removeFromSuperview];
        isShowing = NO;
    }];
}

+(void)windowWholeButtonClick{
    if (canTouchToDismiss) {
        [self dismiss];
        if (touchDismissBlock) {
            touchDismissBlock();
        }
    }
}

+(void)initPulsingLayer{
    [indicatingView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (int i = 0; i < 3; i++) {
        CALayer *pulsingLayer = [CALayer layer];
        pulsingLayer.frame = indicatingView.layer.bounds;
        pulsingLayer.backgroundColor = indicatingView.backgroundColor.CGColor;
        pulsingLayer.cornerRadius = pulsingLayer.bounds.size.width/2;
        pulsingLayer.masksToBounds = YES;
        [indicatingView.layer addSublayer:pulsingLayer];
        
        CAAnimationGroup *group = [self downRefreshingBaseAnimationWithBetweenOffset:i*0.7];
        [pulsingLayer addAnimation:group forKey:@"XYPulsingIndicatorView_indicator_layer_pulsing"];
        group.delegate = self;
        
        [pulsingLayer XYPulsingIndicatorView_pause];
    }
}

+(CAAnimationGroup *)downRefreshingBaseAnimationWithBetweenOffset:(float)offset{
    CAAnimationGroup *baseAnimationGroup = [[CAAnimationGroup alloc] init];
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    float animationDuration = 2.f;
    
    baseAnimationGroup.fillMode = kCAFillModeBoth;
    baseAnimationGroup.beginTime = offset + animationDuration;
    baseAnimationGroup.duration = animationDuration;
    baseAnimationGroup.repeatCount = HUGE_VAL;
    baseAnimationGroup.removedOnCompletion = NO;
    baseAnimationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.autoreverses = NO;
    scaleAnimation.fromValue = [NSNumber numberWithDouble:1.0];
    scaleAnimation.toValue = [NSNumber numberWithDouble:3.0];
    
    
    CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:0.3],[NSNumber numberWithDouble:0.1],[NSNumber numberWithDouble:0.0]];
    opacityAnimation.keyTimes = @[[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:0.25],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:1.0]];
    baseAnimationGroup.animations = @[scaleAnimation,opacityAnimation];
    
    return baseAnimationGroup;
}

-(void)dealloc{
    [self.class dismiss];
    windowWholeButton = nil;
}

@end

@implementation CALayer (XYPulsingIndicatorView_PauseResume)

-(void)XYPulsingIndicatorView_pause{
    self.speed = 0.0;
    self.hidden = YES;
}

-(void)XYPulsingIndicatorView_resume{
    self.speed = 1.0;
    self.hidden = NO;
}

-(void)XYPulsingIndicatorView_reset{
    self.speed = 0.0;
    //    self.hidden = YES;
}

@end
