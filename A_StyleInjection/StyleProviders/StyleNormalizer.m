//
//  NormalizedStyleManager.m
//  A_StyleInjection
//
//  Created by Animax Deng on 6/3/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "StyleNormalizer.h"
#import "A_ColorHelper.h"
#import "NSString+Regex.h"

@implementation StyleNormalizer

+ (id)normalize:(id)rawValue {
    if (![rawValue isKindOfClass:[NSString class]]) {
        return rawValue;
    }
    
    id output = nil;
    
    output = [StyleNormalizer convertColor:rawValue];
    if (output) { return output; }
    
    output = [StyleNormalizer covertCGColor:rawValue];
    if (output) { return output; }
    
    output = [StyleNormalizer convertFont:rawValue];
    if (output) { return output; }
    
    return rawValue;
}

+ (id)convertColor:(NSString *)inputValue {
    //color format example: #000000
    if ([inputValue matchRegexFormat:@"^#(\\d|[A-F]){6}$"]) {
        return [A_ColorHelper A_ColorMakeFormString:inputValue];
    }
    return nil;
}
+ (id)convertFont:(NSString *)inputValue {
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

+ (id)covertCGColor:(NSString *)inputValue {
    //color format example: CG#000000
    if ([inputValue matchRegexFormat:@"^CG#(\\d|[A-F]){6}$"]) {
        return (id)[A_ColorHelper A_ColorMakeFormString:[inputValue substringFromIndex:2]].CGColor;
    }
    return nil;
}

@end
