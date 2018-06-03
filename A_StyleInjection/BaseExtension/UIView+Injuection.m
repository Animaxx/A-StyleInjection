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

#define kStyleIdentifier            @"AssociatedStyleIdentifier"

#define kAssociatedViewSettingDict  @"AssociatedViewSettingDict"
#define kAssociatedParentController @"AssociatedParentController"

@dynamic styleIdentifier, parentController;

static IMP __original_WillMoveToWindow_Method_Imp;

- (id)fetchAssociateValue:(NSString *)key {
    NSString *value = objc_getAssociatedObject(self, @selector(key));
    return value;
}
- (void)setAssociateValue:(id)value withKey:(NSString *)key type:(objc_AssociationPolicy)policyType {
    objc_setAssociatedObject(self, @selector(key), value, policyType);
}

- (NSString *)styleIdentifier {
    return [self fetchAssociateValue:kStyleIdentifier];
}
- (void)setStyleIdentifier:(NSString *)value {
    [self setAssociateValue:value withKey:kStyleIdentifier type:OBJC_ASSOCIATION_COPY_NONATOMIC];
}

- (UIViewController *)parentController {
    return [self fetchAssociateValue:kAssociatedParentController];
}
- (void)setParentController:(UIViewController *)vc {
    [self setAssociateValue:vc withKey:kAssociatedParentController type:OBJC_ASSOCIATION_ASSIGN];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __original_WillMoveToWindow_Method_Imp = method_setImplementation(class_getInstanceMethod([self class],@selector(didMoveToWindow)),(IMP)__A_InjuectionDidMoveToWindow);
    });
}

void __A_InjuectionDidMoveToWindow (id self,SEL _cmd) {
    [self loadStyle:NO];
    ((void(*)(id,SEL))__original_WillMoveToWindow_Method_Imp)(self, _cmd);
}

- (void)loadStyle:(BOOL)isReloadSubviews {
    NSDictionary<NSString *, id> *setting = [[A_InjuectionManager share] getNormalizedStyle:self];
    if (setting) {
        [self __setupStyle:setting];
    }
    
    if (isReloadSubviews) {
        for (UIView *subview in [self subviews]) {
            [subview loadStyle:isReloadSubviews];
        }
    }
}

- (UIViewController *)__findParentController {
    if ([self parentController]) {
        return [self parentController];
    } else {
        for (UIView* next = [self superview]; next; next = next.superview) {
            UIResponder* nextResponder = [next nextResponder];
            
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                UIViewController *parent = (UIViewController*)nextResponder;
                [self setParentController:parent];
                return parent;
            }
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
    [self setValue:value forKey:keypath];
}

@end
