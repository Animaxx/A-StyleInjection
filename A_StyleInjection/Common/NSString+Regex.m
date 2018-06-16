//
//  NSString+Regex.m
//  A_StyleInjection
//
//  Created by Animax Deng on 6/16/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

- (BOOL)matchRegexFormat:(NSString *)regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}
- (NSString *)extractFirstRegex:(NSString *)regex {
    NSError *error = nil;
    NSRegularExpression *r = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        return nil;
    }
    
    NSTextCheckingResult *reuslt = [r firstMatchInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    NSString *resultStr = nil;
    
    if ([reuslt numberOfRanges] > 1) {
        resultStr = [self substringWithRange:[reuslt rangeAtIndex:1]];
    }
    
    return resultStr;
}

@end
