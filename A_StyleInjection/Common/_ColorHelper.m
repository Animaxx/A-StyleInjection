//
//  ColorHelper.m
//  A-IOSHelper
//
//  Created by Animax.
//  Copyright (c) 2014 Animax Deng. All rights reserved.
//

#import "_ColorHelper.h"

@implementation _ColorHelper

+ (NSNumber*) _ToNumber: (NSString*) hex {
    hex = [hex uppercaseString];
    
    int val = 0;
    int res = 0;
    
    for (int i = 0; i < 2; i++) {
        char c = [hex characterAtIndex:i];
        
        switch (c) {
            case 'A':
                val = 10;
                break;
            case 'B':
                val = 11;
                break;
            case 'C':
                val = 12;
                break;
            case 'D':
                val = 13;
                break;
            case 'E':
                val = 14;
                break;
            case 'F':
                val = 15;
                break;
            default:
                val = [[NSNumber numberWithChar:c] intValue] - 48;
                if (val < 0 || val > 9) {
                    val = 0;
                }
                
                break;
        }
        
        res += val * pow(16, 1 - i);
    }
    
    return [NSNumber numberWithInt:res - 1];
}
+ (NSArray *) _SpliteColor:(NSString*) colorString {
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:3];
    
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    
    for (int i = 0; i < 3; i++) {
        NSRange range = NSMakeRange(i * 2, 2);
        [colors addObject: [self _ToNumber: [colorString substringWithRange:range]]];
    }
    
    return colors;
}

+ (UIColor*) CrateColorForm:(NSString*) str {
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    }
    
    if ([str length] != 6) {
        return nil;
    }
    
    NSArray *colors = [self _SpliteColor: str];
    
    NSNumber *red = [colors objectAtIndex:0];
    NSNumber *green = [colors objectAtIndex:1];
    NSNumber *blue = [colors objectAtIndex:2];
    
    UIColor *color = [UIColor colorWithRed:[red floatValue] / 255.0
                                     green:[green floatValue] /255.0
                                      blue:[blue floatValue] /255.0
                                     alpha:1];
    
    return color;
}

@end
