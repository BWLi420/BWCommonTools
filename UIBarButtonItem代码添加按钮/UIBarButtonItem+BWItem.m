//
//  UIBarButtonItem+BWItem.m
//  Miss-Scarlett
//
//  Created by mortal on 16/10/16.
//  Copyright © 2016年 mortal. All rights reserved.
//

#import "UIBarButtonItem+BWItem.h"

@implementation UIBarButtonItem (BWItem)

+ (instancetype)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // button 直接添加到 barButtonItem，会导致 button 的点击范围有问题（范围扩大）
    //使用 view 包装，可以防止这个问题
    UIView *view = [[UIView alloc] initWithFrame:button.bounds];
    [view addSubview:button];
    
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}

+ (instancetype)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selImage forState:UIControlStateSelected];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // button 直接添加到 barButtonItem，会导致 button 的点击范围有问题（范围扩大）
    //使用 view 包装，可以防止这个问题
    UIView *view = [[UIView alloc] initWithFrame:button.bounds];
    [view addSubview:button];
    
    return [[UIBarButtonItem alloc] initWithCustomView:view];
}
@end
