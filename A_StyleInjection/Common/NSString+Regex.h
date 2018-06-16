//
//  NSString+Regex.h
//  A_StyleInjection
//
//  Created by Animax Deng on 6/16/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)

- (BOOL)matchRegexFormat:(NSString *)regex;
- (NSString *)extractFirstRegex:(NSString *)regex;

@end
