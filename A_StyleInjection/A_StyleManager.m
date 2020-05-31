//
//  A_InjuectionManager.m
//  A_StyleInjection
//
//  Created by Animax Deng on 5/13/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "A_StyleManager.h"
#import "UIView+Injuection.h"
#import "StyleValueDecoder.h"
#import "StylePlistProvider.h"
#import "PrivateMethodsHeader.h"

@interface A_StyleManager()

@property (nonatomic, strong) id<InjectionStyleSourceRepository> repository;
@property (nonatomic, strong) id<StyleValueDecoderInterface> styleValueDecodingProvider;

@end

@implementation A_StyleManager

+ (A_StyleManager *)shared {
    static dispatch_once_t pred = 0;
    __strong static A_StyleManager *obj = nil;
    dispatch_once(&pred, ^{
        obj = [[A_StyleManager alloc] init];
        obj.styleValueDecodingProvider = [[StyleValueDecoder alloc] init];
    });
    
    return obj;
}

- (void)setupStyleSourceRepository:(id<InjectionStyleSourceRepository> _Nonnull) source {
    @synchronized (self) {
        BOOL repositoryExist = self.repository != nil;
        self.repository = source;
        if (repositoryExist) {
            [self applyStyle];
        }
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
    UIViewController *parentController = [view parentController];
    if (!parentController) {
        return @{};
    }
    
    NSArray<NSArray<NSString *> *> *path = [view styleResponsePath];
    if (!path || [path count] == 0) {
        return @{};
    }
    
    NSString *viewClassName = NSStringFromClass([view class]);
    viewClassName = [[viewClassName componentsSeparatedByString:@"."] lastObject];
    
    NSString *styleIdentifier = [view styleIdentifier];
    
    NSString *parentControllerName = NSStringFromClass([parentController class]);
    parentControllerName = [[parentControllerName componentsSeparatedByString:@"."] lastObject];
    
    /*
     Information for current view:
     - View class name
     - View identifier
     - View parent controller
     - View reponse path
    */
    NSDictionary<NSString *, id> *styleSetting = [[self getSourceRepository] privodeStyleConfigForView:viewClassName
                                                                                            identifier:styleIdentifier
                                                                                            controller:parentControllerName
                                                                                           reponsePath:path];
    
    for (NSString *key in [styleSetting allKeys]) {
        id value = [styleSetting objectForKey:key];
        value = [self.styleValueDecodingProvider decode:value];
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
    [self.styleValueDecodingProvider regiesterValueDecodeFunc:block];
}

@end
