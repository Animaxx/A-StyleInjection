//
//  A_InjuectionManager.m
//  A_StyleInjection
//
//  Created by Animax Deng on 5/13/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "A_StyleManager.h"
#import "UIView+Injuection.h"
#import "A_ColorHelper.h"
#import "StyleNormalizer.h"
#import "StylePlistProvider.h"

@interface UIView()

- (UIViewController *)__findParentController;

@end

@interface A_StyleManager()

@property (nonatomic, strong) id<InjectionStyleSourceRepository> repository;

@end

@implementation A_StyleManager

+ (A_StyleManager *)shared {
    static dispatch_once_t pred = 0;
    __strong static A_StyleManager *obj = nil;
    dispatch_once(&pred, ^{
        obj = [[A_StyleManager alloc] init];
    });
    
    return obj;
}


- (void)setupStyleSourceRepository:(id<InjectionStyleSourceRepository> _Nonnull) source {
    @synchronized (self) {
        self.repository = source;
    }
}

- (id<InjectionStyleSourceRepository>) getSourceRepository {
    @synchronized (self) {
        if (!self.repository) {
            self.repository = [[StylePlistProvider alloc] init:@"StyleSheet"];
        }
        return self.repository;
    }
}

- (NSDictionary<NSString *, id> *)getNormalizedStyle:(UIView *)view {
    NSString *className = NSStringFromClass([view class]);
    NSString *identifier = [view styleIdentifier];
    UIViewController *parentController = [view __findParentController];
    if (!parentController) {
        return @{};
    }
    
    NSString *controllerName = NSStringFromClass([parentController class]);
    
    NSMutableArray *stylePaths = [[NSMutableArray alloc] init];
    [stylePaths addObject:@[[NSString stringWithFormat:@"@%@", className]]];
    
    if (identifier) {
        [stylePaths addObject:@[[NSString stringWithFormat:@"#%@", identifier]]];
    }
    
    if (controllerName) {
        [stylePaths addObject:@[controllerName, [NSString stringWithFormat:@"@%@", className]]];
        if (identifier) {
            [stylePaths addObject:@[controllerName, [NSString stringWithFormat:@"#%@", identifier]]];
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

- (void)applyStyleToWindow:(UIWindow * _Nonnull)window {
    // TODO:
    
//    [UIFont fontWithName:<#(nonnull NSString *)#> size:<#(CGFloat)#>
}

@end
