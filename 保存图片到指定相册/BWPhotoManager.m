//
//  BWPhotoManager.m
//  Miss-Scarlett
//
//  Created by mortal on 16/10/29.
//  Copyright © 2016年 mortal. All rights reserved.
//

#import "BWPhotoManager.h"
#import <Photos/Photos.h>

@implementation BWPhotoManager

#pragma mark - 获取之前相册
+ (PHAssetCollection *)fetchAssetColletion:(NSString *)albumTitle {
    /**
     PHAssetCollectionTypeAlbum      = 1,
     PHAssetCollectionTypeSmartAlbum = 2,
     PHAssetCollectionTypeMoment     = 3,
     */
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in fetchResult) {
        if ([assetCollection.localizedTitle isEqualToString:albumTitle]) {
            return assetCollection;
        }
    }
    return nil;
}

#pragma mark - 保存图片到自定义相册
+ (void)savePhoto:(UIImage *)image albumTitle:(NSString *)albumTitle completionHandler:(void(^)(BOOL success, NSError *error))completionHandler {
    //自定义相册，必须导入 <Photos/Photos.h> 框架
    
    //    PHPhotoLibrary：相簿（所有相册集合）
    //    PHAsset:图片
    //    PHAssetCollection:相册，所有相片集合
    //    PHAssetChangeRequest:创建，修改，删除图片
    //    PHAssetCollectionChangeRequest:创建，修改，删除相册
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //判断之前是否有相同的相册，获取
        PHAssetCollection *oldCollection = [self fetchAssetColletion:albumTitle];
        
        PHAssetCollectionChangeRequest *assetCollection = nil;
        if (oldCollection) {
            
            assetCollection = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:oldCollection];
        }else {
            
            //创建自定义相册
            assetCollection = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumTitle];
        }
        
        //保存图片到系统相册
        PHAssetChangeRequest *assetChange = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //将保存的图片添加到自定义相册
        PHObjectPlaceholder *placeholder = [assetChange placeholderForCreatedAsset];
        [assetCollection addAssets:@[placeholder]];//添加的是 NSFastEnumeration 类型，相当于数组
        
    } completionHandler:completionHandler];
}

@end
