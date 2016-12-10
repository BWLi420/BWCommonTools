//
//  UIImage+BWImage.h
//  14-图片水印、裁剪
//
//  Created by mortal on 16/9/14.
//  Copyright © 2016年 mortal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BWImage)

/**
 裁剪圆形头像

 @param borderW 圆形头像边框宽度
 @param color   边框颜色
 @param image   需要裁剪的图片

 @return 裁剪过之后的图片
 */
+ (UIImage *)imageWithBorderW:(CGFloat)borderW borderColor:(UIColor *)color image:(UIImage *)image;


/**
 图片加文字水印

 @param addText        需要添加的文字
 @param textPoint      添加文字的位置
 @param textAttributes 添加文字的属性
 @param image          需要添加水印的图片

 @return 添加之后的图片
 */
+ (UIImage *)imageWithAddText:(NSString *)addText textPoint:(CGPoint)textPoint textAttributes:(NSDictionary *)textAttributes image:(UIImage *)image;

/**
 根据颜色生成一张尺寸为1*1的相同颜色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
