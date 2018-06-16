//
//  UIViewController+Injuection.m
//  A_StyleInjection
//
//  Created by Animax Deng on 4/26/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "UIViewController+Injuection.h"
#import "UIView+Injuection.h"
#import "A_InjuectionManager.h"
#import <objc/runtime.h>


@implementation UIViewController(Injuection)

static IMP __original_ViewDidLoad_Method_Imp;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __original_ViewDidLoad_Method_Imp = method_setImplementation(class_getInstanceMethod([self class],@selector(viewDidLoad)),(IMP)__A_InjuectionViewDidLoad);
    });
}

void __A_InjuectionViewDidLoad (id self,SEL _cmd) {
    NSString* name = NSStringFromClass(object_getClass(self));
    [self __setSubviewsParams:[[self view] subviews]];
    ((void(*)(id,SEL))__original_ViewDidLoad_Method_Imp)(self, _cmd);
}
- (NSArray<NSString *> *)__searchProperties {
    u_int count;
    objc_property_t *properties= class_copyPropertyList ([self class], &count);
    NSMutableArray<NSString *> *list = [[NSMutableArray alloc] init];
    
    for (int i= 0; i < count; i++) {
        NSString *properyName = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([[self valueForKey:properyName] isKindOfClass:[UIView class]]) {
            [list addObject:properyName];
        }
    }
    
    return list;
}

- (void)__setSubviewsParams:(NSArray<UIView *> *)views {
    for (UIView *itemView in views) {
        [itemView setParentController:self];
        
        if ([itemView subviews] > 0) {
            [self __setSubviewsParams:[itemView subviews]];
        }
    }
}

+(BOOL)__checkIfObject:(id)object overridesSelector:(SEL)selector {
    Class objSuperClass = [object superclass];
    BOOL isMethodOverridden = NO;
    
    while (objSuperClass != Nil) {
        
        isMethodOverridden = [object methodForSelector: selector] != [objSuperClass instanceMethodForSelector: selector];
        
        if (isMethodOverridden) {
            break;
        }
        objSuperClass = [objSuperClass superclass];
    }
    
    return isMethodOverridden;
}

@end
