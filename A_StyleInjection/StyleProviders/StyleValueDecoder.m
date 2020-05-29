//
//  NormalizedStyleManager.m
//  A_StyleInjection
//
//  Created by Animax Deng on 6/3/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "StyleValueDecoder.h"
#import "A_ColorHelper.h"
#import "NSString+Regex.h"

@interface StyleValueDecoder()

@property NSMutableArray *normalizeFuncs;

@end

@implementation StyleValueDecoder

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.normalizeFuncs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)regiesterValueDecodeFunc:(StyleValueDecodeFuncBlock _Nonnull)funcBlock {
    [self.normalizeFuncs addObject:[funcBlock copy]];
}
- (id)decode:(id)rawValue {
    id output = [self __systemNormalizeFunc:rawValue];
    if (output) { return output; }
    
    for (id (^item)(id raw) in self.normalizeFuncs) {
        output = item(rawValue);
        if (output) {
            return output;
        }
    }
    
    return rawValue;
}

- (id)__systemNormalizeFunc:(id)rawValue {
    id output = nil;
    if ([rawValue isKindOfClass:[NSString class]]) {
        output = [self __convertColor:rawValue];
        if (output) { return output; }
        
        output = [self __covertCGColor:rawValue];
        if (output) { return output; }
        
        output = [self __convertFont:rawValue];
        if (output) { return output; }
    }
    return nil;
}

- (id)__convertColor:(NSString *)inputValue {
    //color format example: #000000
    if ([inputValue matchRegexFormat:@"^#(\\d|[A-F]){6}$"]) {
        return [A_ColorHelper A_ColorMakeFormString:inputValue];
    }
    return nil;
}
- (id)__convertFont:(NSString *)inputValue {
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
- (id)__covertCGColor:(NSString *)inputValue {
    //color format example: CG#000000
    if ([inputValue matchRegexFormat:@"^CG#(\\d|[A-F]){6}$"]) {
        return (id)[A_ColorHelper A_ColorMakeFormString:[inputValue substringFromIndex:2]].CGColor;
    }
    return nil;
}

@end
