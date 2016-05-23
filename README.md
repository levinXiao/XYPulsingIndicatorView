# XYPulsingIndicatorView

这个一个 pusling分格的indicatorView 适用于全屏的等待视图 一般用户长时间的网络请求和加载

方法列表

```
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

+(void)successWithText:(NSString *)successText dismissDuration:(float)duration;

+(void)successWithText:(NSString *)successText imageName:(NSString *)imageName dismissDuration:(float)duration;

+(void)successWithText:(NSString *)successText image:(UIImage *)image dismissDuration:(float)duration;

#pragma mark - 失败
+(void)fail;

+(void)failWithText:(NSString *)failText;

+(void)failWithText:(NSString *)failText dismissDuration:(float)duration;

+(void)failWithText:(NSString *)failText imageName:(NSString *)imageName dismissDuration:(float)duration;

+(void)failWithText:(NSString *)failText image:(UIImage *)image dismissDuration:(float)duration;

#pragma mark - dismiss
//强制消失
+(void)dismiss;

@end
```

用例:
```
//显示成功
- (void)showSuccessButtonClick {
    [XYPulsingIndicatorView show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XYPulsingIndicatorView successWithText:@"成功" dismissDuration:1.0];
    });
}

//显示失败
- (void)showfailureButtonClick {
    [XYPulsingIndicatorView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XYPulsingIndicatorView fail];
    });
}
```
