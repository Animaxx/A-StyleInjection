//
//  A_InjuectionManager.m
//  A_StyleInjection
//
//  Created by Animax Deng on 5/13/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "A_InjuectionManager.h"
#import "UIView+Injuection.h"
#import "A_ColorHelper.h"
#import "StyleNormalizer.h"

@interface UIView()

- (UIViewController *)__findParentController;

@end

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

- (NSDictionary<NSString *, id> *)getStyleByKeypaths:(NSArray<NSArray<NSString *> *> *)setOfKeyPaths {
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

- (NSDictionary<NSString *, id> *)getNormalizedStyle:(UIView *)view {
    NSString *className = NSStringFromClass([view class]);
    NSString *key = [view styleIdentifier];
    UIViewController *parentController = [view __findParentController];
    NSString *controllerName = NSStringFromClass([parentController class]);
    
    NSMutableArray *setOfPaths = [[NSMutableArray alloc] init];
    [setOfPaths addObject:@[[NSString stringWithFormat:@"@%@", className]]];
    [setOfPaths addObject:@[@"GOBAL", [NSString stringWithFormat:@"@%@", className]]];
    
    if (key) {
        [setOfPaths addObject:@[[NSString stringWithFormat:@"#%@", key]]];
        [setOfPaths addObject:@[@"GOBAL", [NSString stringWithFormat:@"#%@", key]]];
    }
    
    if (controllerName) {
        [setOfPaths addObject:@[controllerName, [NSString stringWithFormat:@"@%@", className]]];
        if (key) {
            [setOfPaths addObject:@[controllerName, [NSString stringWithFormat:@"#%@", key]]];
        }
    }
    
    NSDictionary<NSString *, id> *styleSetting = [[A_InjuectionManager share] getStyleByKeypaths:setOfPaths];
    for (NSString *key in [styleSetting allKeys]) {
        id value = [styleSetting objectForKey:key];
        value = [StyleNormalizer normaliz:value];
        [styleSetting setValue:value forKey:key];
    }
    
    return styleSetting;
}

@end
