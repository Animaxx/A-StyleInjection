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

- (NSDictionary *)getStyleByKeypaths:(NSArray<NSArray<NSString *> *> *)setOfKeyPaths {
    NSDictionary *dict = self.styleSource;
    if (!dict) {
        [self setStyleSourceToPlist:@"StyleSheet"];
        dict = self.styleSource;
        if (!dict) {
            return @{};
        }
    }
    
    NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
    for (NSArray<NSString *> *itemKeyPaths in setOfKeyPaths) {
        NSDictionary *itemDict = dict;
        for (NSString *itemkey in itemKeyPaths) {
            if (itemDict && [itemDict isKindOfClass:[NSDictionary class]]) {
                itemDict = ([itemDict objectForKey:itemkey] ? [itemDict objectForKey:itemkey] : nil);
            } else {
                itemDict = nil;
            }
        }
        
        if (itemDict) {
            [setting addEntriesFromDictionary:itemDict];
        }
    }
    
    return setting;
}




@end
