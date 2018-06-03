//
//  NormalizedStyleManager.m
//  A_StyleInjection
//
//  Created by Animax Deng on 6/3/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "StyleNormalizer.h"
#import "A_ColorHelper.h"

@implementation StyleNormalizer

+ (id)normaliz:(id)rawValue {
    id output = rawValue;
    output = [StyleNormalizer convertColor:output];
    
    return output;
}

+ (id)convertColor:(NSString *)inputValue {
    if (![inputValue isKindOfClass:[NSString class]]) {
        return inputValue;
    }
    
    NSString *regex = @"^#(\\d|[A-F]){6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:inputValue]) {
        return [A_ColorHelper A_ColorMakeFormString:inputValue];
    }
    
    return inputValue;
}

@end
