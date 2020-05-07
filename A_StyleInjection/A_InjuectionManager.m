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
#import "PlistStyleSourceProvider.h"

@interface UIView()

- (UIViewController *)__findParentController;

@end

@interface A_InjuectionManager()

//@property (nonatomic, strong) NSDictionary *styleSource;
@property (nonatomic, strong) id<InjectionStyleSourceRepository> repository;

@end

@implementation A_InjuectionManager

+ (A_InjuectionManager *)shared {
    static dispatch_once_t pred = 0;
    __strong static A_InjuectionManager *obj = nil;
    dispatch_once(&pred, ^{
        obj = [[A_InjuectionManager alloc] init];
    });
    
    return obj;
}

- (void)setStyleSourceRepository:(id<InjectionStyleSourceRepository> _Nonnull) source {
    @synchronized (self) {
        self.repository = source;
    }
}
- (id<InjectionStyleSourceRepository>) getSourceRepository {
    @synchronized (self) {
        if (!self.repository) {
            self.repository = [[PlistStyleSourceProvider alloc] init:@"StyleSheet"];
        }
        return self.repository;
    }
}

- (NSDictionary<NSString *, id> *)getNormalizedStyle:(UIView *)view {
    NSString *className = NSStringFromClass([view class]);
    NSString *key = [view styleIdentifier];
    UIViewController *parentController = [view __findParentController];
    if (!parentController) {
        return @{};
    }
    
    NSString *controllerName = NSStringFromClass([parentController class]);
    
    NSMutableArray *stylePaths = [[NSMutableArray alloc] init];
    [stylePaths addObject:@[[NSString stringWithFormat:@"@%@", className]]];
    [stylePaths addObject:@[@"GOBAL", [NSString stringWithFormat:@"@%@", className]]];
    
    if (key) {
        [stylePaths addObject:@[[NSString stringWithFormat:@"#%@", key]]];
        [stylePaths addObject:@[@"GOBAL", [NSString stringWithFormat:@"#%@", key]]];
    }
    
    if (controllerName) {
        [stylePaths addObject:@[controllerName, [NSString stringWithFormat:@"@%@", className]]];
        if (key) {
            [stylePaths addObject:@[controllerName, [NSString stringWithFormat:@"#%@", key]]];
        }
    }
    
    NSDictionary<NSString *, id> *styleSetting = [[self getSourceRepository] getStyleByKeypaths:stylePaths];
    
    for (NSString *key in [styleSetting allKeys]) {
        id value = [styleSetting objectForKey:key];
        value = [StyleNormalizer normalize:value];
        [styleSetting setValue:value forKey:key];
    }
    
    return styleSetting;
}

@end
