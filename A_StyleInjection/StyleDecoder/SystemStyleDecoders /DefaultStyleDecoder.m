//
//  NormalizedStyleManager.m
//  A_StyleInjection
//
//  Created by Animax Deng on 6/3/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "DefaultStyleDecoder.h"
#import "_ColorHelper.h"
#import "NSString+Regex.h"

@implementation DefaultStyleDecoder

- (id)tryDecode:(id _Nonnull)rawValue {
    id output = nil;
    
    output = [self __convertColor:rawValue];
    if (output) return output;
    
    output = [self __convertFont:rawValue];
    if (output) return output;
    
    output = [self __convertCGColor:rawValue];
    if (output) return output;
    
    output = [self __convertUIImage:rawValue];
    if (output) return output;
    
    return output;
}

- (id)__convertColor:(id)inputValue {
    if (![inputValue isKindOfClass:[NSString class]]) { return nil; }
    
    //color format example: #000000
    if ([inputValue matchRegexFormat:@"^#(\\d|[A-F]){6}$"]) {
        return [_ColorHelper CrateColorForm:inputValue];
    }
    return nil;
}
- (id)__convertFont:(id)inputValue {
    if (![inputValue isKindOfClass:[NSString class]]) { return nil; }
    
    //font format example: $"Helvetica Neue":17
    if ([inputValue matchRegexFormat:@"^\\$\\\"[a-zA-z -_]+\\\"\\:[0-9]*$"]) {
        NSString *fontNameStr = [inputValue extractFirstRegex:@"^\\$\\\"([a-zA-Z -_]+)\\\""];
        NSString *fontSizeStr = [inputValue extractFirstRegex:@":([0-9]*)$"];
        
        if (fontNameStr && fontSizeStr) {
            UIFont *font = [UIFont fontWithName:fontNameStr size:[fontSizeStr floatValue]];
            if (font) {
                return font;
            }
        }
        
        if (fontSizeStr) {
            UIFont *font = [UIFont systemFontOfSize:[fontSizeStr floatValue]];
            if (font) {
                return font;
            }
        }
    }
    
    return nil;
}
- (id)__convertCGColor:(id)inputValue {
    if (![inputValue isKindOfClass:[NSString class]]) { return nil; }
    
    //color format example: CG#000000
    if ([inputValue matchRegexFormat:@"^CG#(\\d|[A-F]){6}$"]) {
        return (id)[_ColorHelper CrateColorForm:[inputValue substringFromIndex:2]].CGColor;
    }
    return nil;
}
- (id)__convertUIImage:(id)inputValue {
    if (![inputValue isKindOfClass:[NSString class]]) { return nil; }
    
    //image format example: IMG(imageName)
    //Loading the image as `imageName` from mainBundle
    NSString *imageName = [inputValue extractFirstRegex:@"^IMG\\(([\\d|\\w]*)\\)$"];
    if (imageName) {
        return [UIImage imageNamed:imageName];
    }
    return nil;
}

@end
