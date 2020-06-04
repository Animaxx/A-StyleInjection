//
//  UIView+Injuection.m
//  A_StyleInjection
//
//  Created by Animax Deng on 5/13/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "UIView+Injuection.h"
#import <objc/runtime.h>
#import "A_StyleManager.h"
#import "PrivateMethodsHeader.h"

@implementation UIView(Injuection)

static char *viewStyleApplied = "aAssociatedStyleApplied";
static char *viewStyleIdentifier = "aAssociatedStyleIdentifier";
static char *viewParentController = "aAssociatedParentController";
static char *viewResponsePath = "aAssociatedResponsePath";

@dynamic styleIdentifier, parentController, isStyleApplied;

static IMP __original_DidMoveToWindow_Method_Imp;

#pragma mark - Associate values
- (id)fetchAssociateValue:(char *)key {
    id value = objc_getAssociatedObject(self, key);
    return value;
}
- (void)setAssociateValue:(id)value withKey:(char *)key type:(objc_AssociationPolicy)policyType {
    objc_setAssociatedObject(self, key, value, policyType);
}

- (NSString *)styleIdentifier {
    return [self fetchAssociateValue:viewStyleIdentifier];
}
- (void)setStyleIdentifier:(NSString *)value {
    [self setAssociateValue:value withKey:viewStyleIdentifier type:OBJC_ASSOCIATION_COPY_NONATOMIC];
}

- (UIViewController *)parentController {
    return [self fetchAssociateValue:viewParentController];
}
- (void)setParentController:(UIViewController *)vc {
    [self setAssociateValue:vc withKey:viewParentController type:OBJC_ASSOCIATION_ASSIGN];
}
- (BOOL)isStyleApplied {
    id value = [self fetchAssociateValue:viewStyleApplied];
    return !value && [value boolValue];
}

- (NSArray<NSArray<NSString *> *> *)styleResponsePath {
    return [self fetchAssociateValue:viewResponsePath];
}
- (void)setStyleResponsePath:(NSArray *)chain {
    [self setAssociateValue:chain withKey:viewResponsePath type:OBJC_ASSOCIATION_RETAIN];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class selfCls = [self class];
        SEL selector = @selector(didMoveToWindow);
        IMP replaceImpMethod = (IMP)__A_InjuectionDidMoveToWindow;

        Method originalMethod = class_getInstanceMethod(selfCls, selector);

        IMP originalMethodImpl = nil;
        if( originalMethod ) {
            const char* methodTypes = method_getTypeEncoding(originalMethod);
            originalMethodImpl = class_replaceMethod(selfCls, selector, replaceImpMethod, methodTypes);
            if( !originalMethodImpl ) {
                originalMethodImpl = method_getImplementation(originalMethod);
            }
        }

        if (originalMethodImpl) {
            __original_DidMoveToWindow_Method_Imp = originalMethodImpl;
        }
    });
}

void __A_InjuectionDidMoveToWindow (id self,SEL _cmd) {
    [self loadStyle:YES forceReload:NO];
    
    if (__original_DidMoveToWindow_Method_Imp) {
        ((void(*)(id,SEL))__original_DidMoveToWindow_Method_Imp)(self, _cmd);
    }
}

- (void)loadStyle:(BOOL)isReloadSubviews forceReload:(BOOL)forceReload {
    if (!forceReload && [self isStyleApplied]) {
        return;
    }
    
    if (![self __traceResponseChain]) {
        return;
    }
    
    [self setAssociateValue:@(true) withKey:viewStyleApplied type:OBJC_ASSOCIATION_COPY];
    
    __weak UIView *blockSelf = self;
    
    void(^loadSubviewsStyle)(void)  = ^ {
        for (UIView *subview in [blockSelf subviews]) {
            
            // Set parent controller and response path to subview to reduce consuming
            // Note: if current controller has child then subview might not be the same parent controller
            if ([[[blockSelf parentController] childViewControllers] count] <= 0) {
                [subview setParentController:[blockSelf parentController]];
                NSMutableArray<NSArray<NSString *> *> * subpath = [[blockSelf styleResponsePath] mutableCopy];
                NSString *styleId = [subview styleIdentifier];
                if (!styleId) {
                    styleId = (NSString *)[NSNull null];
                }
                [subpath addObject:@[ NSStringFromClass([subview class]), styleId]];
            }
            [subview loadStyle:isReloadSubviews forceReload:forceReload];
        }
    };
    
    [[A_StyleManager shared] fetchNormalizedStyle:self completed:^(NSDictionary<NSString *,id> * _Nonnull styleSetting) {
        if (styleSetting && [styleSetting count] > 0) {
            [blockSelf __setupStyle:styleSetting];
        }
        
        if (isReloadSubviews && [[[blockSelf parentController] childViewControllers] count] <= 0) {
            loadSubviewsStyle();
        }
    }];
    
    if (isReloadSubviews && [[[self parentController] childViewControllers] count] > 0) {
        loadSubviewsStyle();
    }
    
}

- (BOOL)__traceResponseChain {
    if ([self parentController] && [self styleResponsePath] && [[self styleResponsePath] count] > 0) {
        return true;
    }
    
    NSMutableArray<NSArray<NSString *> *> *paths = [[NSMutableArray alloc] init];
    
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]]) {
        
        NSString *responderClass = NSStringFromClass([responder class]);
        NSString *responderStyleID = [(UIView *)responder styleIdentifier];
        
        if (!responderClass) {
            responderClass = (NSString *)[NSNull null];
        }
        if (!responderStyleID) {
            responderStyleID = (NSString *)[NSNull null];
        }
        
        [paths insertObject:@[responderClass, responderStyleID] atIndex:0];
        
        responder = [responder nextResponder];
    }
    
    if (responder && [responder isKindOfClass:[UIViewController class]]) {
        [self setParentController:(UIViewController *)responder];
        [self setStyleResponsePath:paths];
    }
    
    return (responder && [responder isKindOfClass:[UIViewController class]]);
}

- (void)__setupStyle:(NSDictionary *)setting {
    void(^runBlock)(void)  = ^ {
        for (NSString *key in setting) {
            id itemValue = [setting objectForKey:key];
            [self injuectStyle:itemValue tokey:key];
        }
    };
    if ([NSThread isMainThread]) {
        runBlock();
    } else {
        dispatch_async(dispatch_get_main_queue(), runBlock);
    }
}

- (void)injuectStyle:(id)value tokey:(NSString *)keypath {
    NSAssert(NSThread.isMainThread, @"[Style Manager Error]\nStyle need to set in MainThread: %@",
             [NSThread callStackSymbols]);
    
    if ([self __verifyInjuectStyle:value tokey:keypath]) {
        @try {
            [self setValue:value forKeyPath:keypath];
        } @catch (NSException *ex) {
            NSLog(@"[Style Manager Error]\nSet style failed to key `%@` with value: %@ \n              error: %@ ",
                  keypath, value, ex);
        }
    } else {
        NSLog(@"[Style Manager Error]\nSet style with incorrect type: key %@", keypath);
    }
}
- (BOOL)__verifyInjuectStyle:(id)value tokey:(NSString *)keypath {
    // TODO:
    return YES;
}

@end
