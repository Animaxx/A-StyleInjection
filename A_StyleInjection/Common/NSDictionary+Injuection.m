//
//  NSDIctionary+StyleInjuection.m
//  A_StyleInjection
//
//  Created by Animax Deng on 5/18/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "NSDictionary+Injuection.h"
#import "A_ColorHelper.h"

@implementation NSDictionary(Injuection)

- (UIColor *)convertToColor:(NSString *)key {
    return [A_ColorHelper A_ColorMakeFormString:[self objectForKey:key]];
}
- (BOOL)isColorFormat:(NSString *)key {
    NSString *str = [self objectForKey:key];
    if (![str isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSString *regex = @"^#(\\d|[A-F]){6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}

@end
