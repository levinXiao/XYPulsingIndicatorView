//
//  XYPulsingIndicatorView.h
//  XYPulsingIndicatorView
//
//  Created by xiaoyu on 16/5/20.
//  Copyright © 2016年 xiaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYPulsingIndicatorView : UIView


#pragma mark - show
//显示indicator 默认不可点击动画范围外的消失 默认显示文字为@"请稍候..."
+(void)show;
//显示indicator 该方法可以点击外围使其消失
+(void)showTouchableWithText:(NSString *)text;

+(void)showWithText:(NSString *)text;

//在还未完成刷新的时候 点击外部取消的时候触发的操作
//注意: 在success和fail使自己消息的函数中是不会触发这个block的
+(void)showWithText:(NSString *)text touchToDismissComplete:(void (^)())touchDimissComplete;

#pragma mark - 成功
+(void)success;

+(void)successWithText:(NSString *)successText;

+(void)successWithText:(NSString *)successText dismissDuration:(float)duration finish:(void(^)())finish;

+(void)successWithText:(NSString *)successText imageName:(NSString *)imageName dismissDuration:(float)duration finish:(void(^)())finish;

+(void)successWithText:(NSString *)successText image:(UIImage *)image dismissDuration:(float)duration finish:(void(^)())finish;

#pragma mark - 失败
+(void)fail;

+(void)failWithText:(NSString *)failText;

+(void)failWithText:(NSString *)failText dismissDuration:(float)duration finish:(void(^)())finish;

+(void)failWithText:(NSString *)failText imageName:(NSString *)imageName dismissDuration:(float)duration finish:(void(^)())finish;

+(void)failWithText:(NSString *)failText image:(UIImage *)image dismissDuration:(float)duration finish:(void(^)())finish;

#pragma mark - dismiss
//强制消失
+(void)dismiss;

@end

@interface CALayer (XYPulsingIndicatorView_PauseResume)

-(void)XYPulsingIndicatorView_pause;

-(void)XYPulsingIndicatorView_resume;

-(void)XYPulsingIndicatorView_reset;

@end