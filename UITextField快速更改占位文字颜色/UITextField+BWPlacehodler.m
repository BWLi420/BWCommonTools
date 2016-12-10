//
//  UITextField+BWPlacehodler.m
//  Miss-Scarlett
//
//  Created by mortal on 16/10/22.
//  Copyright © 2016年 mortal. All rights reserved.
//

#import "UITextField+BWPlacehodler.h"

@implementation UITextField (BWPlacehodler)

- (void)setPlacehodlerColor:(UIColor *)placehodlerColor {
    if (self.placeholder.length == 0) {
        self.placeholder = @" ";
    }
    
    UILabel *placehodlerLabel = [self valueForKeyPath:@"placeholderLabel"];
    placehodlerLabel.textColor = placehodlerColor;
}

- (UIColor *)placehodlerColor {
    UILabel *placehodlerLabel = [self valueForKeyPath:@"placeholderLabel"];
    return placehodlerLabel.textColor;
}

@end
