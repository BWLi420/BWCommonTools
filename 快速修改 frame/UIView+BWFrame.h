//
//  UIView+BWFrame.h
//  （城觅）
//
//  Created by mortal on 16/9/20.
//  Copyright © 2016年 mortal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BWFrame)

/**
 1.一般情况下，分类只能添加方法
 2.如果想要添加属性，必须重写该属性的set与get方法
 3.使用@property不会生成带有下划线的成员属性，会声明set与get方法
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end
