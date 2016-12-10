//
//  BWFileManager.h
//  Miss-Scarlett
//
//  Created by mortal on 16/10/24.
//  Copyright © 2016年 mortal. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 处理文件 */
@interface BWFileManager : NSFileManager

/**
 指定一个文件夹路径，获取该文件夹的尺寸

 @param directoryPath 指定的文件夹路径
 */
+ (void)getDirectorySize:(NSString *)directoryPath completion:(void(^)())completion;


/**
 指定一个文件夹路径，删除该文件夹下的内容

 @param directoryPath 指定的文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;


/**
  指定一个文件夹路径，获取含当前文件夹尺寸的字符串

  @param directoryPath 指定的文件夹路径
  */
+ (void)directorySizeString:(NSString *)directoryPath completion:(void(^)(NSString *))completion;

@end
