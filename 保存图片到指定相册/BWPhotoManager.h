//
//  BWPhotoManager.h
//  Miss-Scarlett
//
//  Created by mortal on 16/10/29.
//  Copyright © 2016年 mortal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWPhotoManager : NSObject

//保存图片到指定相册
+ (void)savePhoto:(UIImage *)image albumTitle:(NSString *)albumTitle completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;

@end
