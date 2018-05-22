//
//  A_InjuectionManager.m
//  A_StyleInjection
//
//  Created by Animax Deng on 5/13/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "A_InjuectionManager.h"

@interface A_InjuectionManager()

@property (nonatomic, strong) NSDictionary *styleSource;

@end

@implementation A_InjuectionManager

+ (A_InjuectionManager *)share {
    static dispatch_once_t pred = 0;
    __strong static A_InjuectionManager *obj = nil;
    dispatch_once(&pred, ^{
        obj = [[A_InjuectionManager alloc] init];
    });
    
    return obj;
}

- (void)setStyleSourceToDict:(NSDictionary *)dict {
    self.styleSource = [dict copy];
}
- (void)setStyleSourceToPlist:(NSString *)fileName {
    [self setStyleSourceToPlist:fileName withBundle:[NSBundle mainBundle]];
}
- (void)setStyleSourceToPlist:(NSString *)fileName withBundle:(NSBundle *)bundle {
    NSString *path = [bundle pathForResource:fileName ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    self.styleSource = dict;
}

- (NSDictionary *)getStyleByKeypaths:(NSArray<NSString *> *)keyPaths {
    NSDictionary *dict = self.styleSource;
    if (!dict) {
        [self setStyleSourceToPlist:@"StyleSheet"];
        dict = self.styleSource;
        if (!dict) {
            return @{};
        }
    }
    
    for (NSString *item in keyPaths) {
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            dict = ([dict objectForKey:item] ? [dict objectForKey:item] : nil);
        } else {
            return @{};
        }
        
        if (!dict) {
            return @{};
        }
    }
    
    if (!dict) {
        return @{};
    } else {
        return [dict copy];
    }
}

- (NSDictionary *)getStyleSetByController:(NSString *)controllerName class:(Class)itemClass styleKey:(NSString *)key {
    NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
    
    // Loading from the path
    [setting addEntriesFromDictionary: [self getStyleByKeypaths:@[controllerName, key]]];
    
    // TODO: Loading global settings
    // Loading from global
    //    NSStringFromClass(itemClass)
    
    return setting;
}

@end
