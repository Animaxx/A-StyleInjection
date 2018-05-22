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

@implementation UIView(Injuection)

#define kStyleIdentifier    @"StyleIdentifier"

@dynamic styleIdentifier;

static IMP __original_WillMoveToWindow_Method_Imp;

- (NSString *)styleIdentifier {
    id key = kStyleIdentifier;
    NSString *value = objc_getAssociatedObject(self, @selector(key));
    key = nil;
    return value;
}
- (void)setStyleIdentifier:(NSString *)value {
    id key = kStyleIdentifier;
    objc_setAssociatedObject(self, @selector(key), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    key = nil;
}

//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        __original_WillMoveToWindow_Method_Imp = method_setImplementation(class_getInstanceMethod([self class],@selector(willMoveToWindow:)),(IMP)__A_InjuectionWillMoveToWindow);
//    });
//}
//void __A_InjuectionWillMoveToWindow (id self,SEL _cmd) {
//    NSString* name = NSStringFromClass(object_getClass(self));
//    NSLog(@"InjuectionWillMoveToWindow %@", name);
//
//    ((void(*)(id,SEL))__original_WillMoveToWindow_Method_Imp)(self, _cmd);
//}

- (void)setupStyle:(NSDictionary *)setting {
    for (NSString *key in setting) {
        id itemValue = [setting objectForKey:key];
        if ([setting isColorFormat:key]) {
            itemValue = [setting convertToColor:key];
        }
        
        [self setValue:itemValue forKeyPath:key];
    }
}



@end
