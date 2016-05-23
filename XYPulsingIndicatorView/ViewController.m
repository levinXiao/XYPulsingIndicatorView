//
//  ViewController.m
//  XYPulsingIndicatorView
//
//  Created by xiaoyu on 16/5/20.
//  Copyright © 2016年 xiaoyu. All rights reserved.
//

#import "ViewController.h"
#import "XYPulsingIndicatorView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *showSuccessButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showSuccessButton.frame = (CGRect){20,50,200,30};
    [showSuccessButton setTitle:@"show in 3 success" forState:UIControlStateNormal];
    [showSuccessButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [showSuccessButton addTarget:self action:@selector(showSuccessButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showSuccessButton];
    
    UIButton *showfailureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showfailureButton.frame = (CGRect){20,80,200,30};
    [showfailureButton setTitle:@"show in 3 failure" forState:UIControlStateNormal];
    [showfailureButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [showfailureButton addTarget:self action:@selector(showfailureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showfailureButton];
    
}

-(void)showSuccessButtonClick{
    [XYPulsingIndicatorView show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XYPulsingIndicatorView successWithText:@"成功" dismissDuration:1.0];
    });
}

-(void)showfailureButtonClick{
    [XYPulsingIndicatorView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [XYPulsingIndicatorView fail];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
