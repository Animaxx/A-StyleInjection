//
//  ColorHelper.h
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface A_ColorHelper : NSObject

+ (UIColor* _Nonnull) MakeColorByR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b;
+ (UIColor* _Nullable) A_ColorMakeFormString:(NSString* _Nonnull) str;

@end
