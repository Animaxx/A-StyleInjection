//
//  DebugManager.m
//  A_StyleInjection
//
//  Created by Animax Deng on 6/8/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import "DebugManager.h"

@implementation DebugManager

+ (void)logError:(NSString *)message error:(NSError *)err {
    // Display log in console
    // [NSThread callStackSymbols]
    NSLog(@"===== [Style Manager Error] =====\n%@\n\n%@  ",message, err);
}

@end
