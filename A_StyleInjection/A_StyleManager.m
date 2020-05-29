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
#import "StyleValueDecoder.h"
#import "StylePlistProvider.h"

@interface UIView()

- (UIViewController *)__findParentController;

@end

@interface A_StyleManager()

@property (nonatomic, strong) id<InjectionStyleSourceRepository> repository;
@property (nonatomic, strong) id<StyleValueDecoderInterface> styleNormalizeProvider;

@end

@implementation A_StyleManager

+ (A_StyleManager *)shared {
    static dispatch_once_t pred = 0;
    __strong static A_StyleManager *obj = nil;
    dispatch_once(&pred, ^{
        obj = [[A_StyleManager alloc] init];
        obj.styleNormalizeProvider = [[StyleValueDecoder alloc] init];
    });
    
    return obj;
}

- (void)setupStyleSourceRepository:(id<InjectionStyleSourceRepository> _Nonnull) source {
    @synchronized (self) {
        self.repository = source;
    }
}

- (id<InjectionStyleSourceRepository>) getSourceRepository {
    if (self.repository != nil) {
        return self.repository;
    }
    
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
        value = [self.styleNormalizeProvider decode:value];
        [styleSetting setValue:value forKey:key];
    }
    
    return styleSetting;
}

- (void)applyStyle {
    if ([UIApplication sharedApplication].keyWindow) {
        [self applyStyleInWindow:[UIApplication sharedApplication].keyWindow];
    } else {
        NSException *error = [NSException exceptionWithName:@"StyleManagerException" reason:@"KeyWindow is not exist" userInfo:nil];
        @throw error;
    }
}
- (void)applyStyleInWindow:(UIWindow * _Nonnull)window {
    if (window.rootViewController == nil) {
        return;
    }
    
    [window.rootViewController.view loadStyle:YES forceReload:YES];
    [[[window.rootViewController presentedViewController] view] loadStyle:YES forceReload:YES];
    
    if ([window.rootViewController isKindOfClass:[UINavigationController class]]) {
        [[[(UINavigationController *)window.rootViewController visibleViewController] view] loadStyle:YES forceReload:YES];
    }

}

- (void)registerValueDecodeFunc:(StyleValueDecodeFuncBlock _Nonnull)block {
    [self.styleNormalizeProvider regiesterValueDecodeFunc:block];
}

@end
