//
//  UIImage+BWImage.m
//  14-图片水印、裁剪
//
//  Created by mortal on 16/9/14.
//  Copyright © 2016年 mortal. All rights reserved.
//

#import "UIImage+BWImage.h"

@implementation UIImage (BWImage)

+ (UIImage *)imageWithBorderW:(CGFloat)borderW borderColor:(UIColor *)color image:(UIImage *)image{ 
    
    //1.生成一张图片,开启一个位图上下文(大小,图片的宽高 + 2 * 边框宽度)
    CGSize size = CGSizeMake(image.size.width + 2 *borderW, image.size.height + 2 *borderW);
    UIGraphicsBeginImageContext(size);
    
    //2.绘制一个大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    [color set];
    [path fill];
    
    //3.设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderW, borderW, image.size.width, image.size.height)];
    //3.1 把路径设置为裁剪区域
    [clipPath addClip];
    
    //4 把图片绘制到上下文
    [image drawAtPoint:CGPointMake(borderW, borderW)];
    
    //5.从上下文当中获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //6.关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithAddText:(NSString *)addText textPoint:(CGPoint)textPoint textAttributes:(NSDictionary *)textAttributes image:(UIImage *)image {
    
    //生成一张新的图片
    //创建时上下文的大小，决定着生成图片的大小
    UIGraphicsBeginImageContext(image.size);
    
    //将图片绘制到上下文中
    [image drawAtPoint:CGPointZero];
    
    //画文字
    [addText drawAtPoint:textPoint withAttributes:textAttributes];
    
    //把上下文中国所有的内容合成到一起，生成一张新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
