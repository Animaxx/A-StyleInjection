//
//  A_InjuectionManager.m
//  A_StyleInjection
//
//  Created by Animax Deng on 5/13/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "A_StyleManager.h"
#import "UIView+Injuection.h"
#import "StylePlistProvider.h"
#import "PrivateMethodsHeader.h"

#import "SystemStyleValueDecoderFactory.h"

@interface A_StyleManager()

@property (nonatomic, strong) id<InjectionStyleSourceRepository> repository;
@property (nonatomic, strong) NSMutableSet<id<StyleValueDecoderInterface>> *styleDecoderSet;

@end

@implementation A_StyleManager

+ (A_StyleManager *)shared {
    static dispatch_once_t pred = 0;
    __strong static A_StyleManager *obj = nil;
    dispatch_once(&pred, ^{
        obj = [[A_StyleManager alloc] init];
        obj.styleDecoderSet = [[NSMutableSet alloc] init];
        [A_StyleManager _preloadDefaultDecoder:obj.styleDecoderSet];
        obj.enableDebug = false;
    });
    
    return obj;
}
+ (void)_preloadDefaultDecoder:(NSMutableSet<id<StyleValueDecoderInterface>> *)decoderSet {
    SystemStyleValueDecoderFactory *factory = [[SystemStyleValueDecoderFactory alloc] init];
    [decoderSet unionSet:[factory createSystemDefaultStyleDecoders]];
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

- (void)fetchNormalizedStyle:(UIView *)view completed:(void (^)(NSDictionary<NSString *, id> *styleSetting))block {
    UIViewController *parentController = [view parentController];
    if (!parentController) {
        block(@{});
        return;
    }
    
    NSArray<NSArray<NSString *> *> *path = [view styleResponsePath];
    if (!path || [path count] == 0) {
        block(@{});
        return;
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
    [[self getSourceRepository] privodeStyleConfigForView:viewClassName identifier:styleIdentifier controller:parentControllerName reponsePath:path completion:^(NSDictionary<NSString *,id> * _Nonnull styleSetting) {
        
        for (NSString *key in [styleSetting allKeys]) {
            id value = [styleSetting objectForKey:key];
            value = [self _decodeValue:value];
            [styleSetting setValue:value forKey:key];
        }
        
        block(styleSetting);
    }];
}
- (id)_decodeValue:(id)rawValue {
    id output = nil;
    for (id<StyleValueDecoderInterface> item in self.styleDecoderSet) {
        output = [item tryDecode:rawValue];
        if (output) {
            return output;
        }
    }
    return rawValue;
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

- (void)registerValueDecoder:(id<StyleValueDecoderInterface>)decoder {
    @synchronized (self) {
        [self.styleDecoderSet addObject:decoder];
    }
}

@end
