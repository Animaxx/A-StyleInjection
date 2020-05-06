//
//  UIView+Injuection.m
//  A_StyleInjection
//
//  Created by Animax Deng on 5/13/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "UIView+Injuection.h"
#import <objc/runtime.h>
#import "NSDictionary+Injuection.h"
#import "A_InjuectionManager.h"

@implementation UIView(Injuection)

static char *viewStyleIdentifier = "aAssociatedStyleIdentifier";
static char *viewParentController = "aAssociatedParentController";

@dynamic styleIdentifier, parentController, isStyleApplied;

static IMP __original_WillMoveToWindow_Method_Imp;

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
    id value = [self fetchAssociateValue:viewStyleIdentifier];
    return value && [value isKindOfClass:[NSString class]];
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
            __original_WillMoveToWindow_Method_Imp = originalMethodImpl;
        }
    });
}

void __A_InjuectionDidMoveToWindow (id self,SEL _cmd) {
    [self loadStyle:YES forceReload:NO];
    
    if (__original_WillMoveToWindow_Method_Imp) {
        ((void(*)(id,SEL))__original_WillMoveToWindow_Method_Imp)(self, _cmd);
    }
}

- (void)loadStyle:(BOOL)isReloadSubviews forceReload:(BOOL)forceReload {
    if (!forceReload && [self isStyleApplied]) {
        return;
    }
    
    NSDictionary<NSString *, id> *setting = [[A_InjuectionManager share] getNormalizedStyle:self];
    if (setting) {
        [self __setupStyle:setting];
    }
    
    if (isReloadSubviews) {
        for (UIView *subview in [self subviews]) {
            [subview loadStyle:isReloadSubviews forceReload:forceReload];
        }
    }
}

- (UIViewController *)__findParentController {
    if ([self parentController]) {
        return [self parentController];
    } else {
        UIResponder *responder = self;
        while ([responder isKindOfClass:[UIView class]])
            responder = [responder nextResponder];
        
        if (responder && [responder isKindOfClass:[UIViewController class]]) {
            [self setParentController:(UIViewController *)responder];
            return (UIViewController *)responder;
        }
    }
    
    return nil;
}

- (void)__setupStyle:(NSDictionary *)setting {
    for (NSString *key in setting) {
        id itemValue = [setting objectForKey:key];
        [self injuectStyle:itemValue tokey:key];
    }
}

- (void)injuectStyle:(id)value tokey:(NSString *)keypath {
    @try {
        [self setValue:value forKeyPath:keypath];
    } @catch (NSException *ex) {
        NSLog(@"Set style error: key %@ ", ex);
    }
}

@end
