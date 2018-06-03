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

@dynamic styleIdentifier;

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

- (UIViewController *)ParentController {
    return [self fetchAssociateValue:kAssociatedParentController];
}
- (void)setParentController:(UIViewController *)vc {
    [self setAssociateValue:vc withKey:kAssociatedParentController type:OBJC_ASSOCIATION_ASSIGN];
}

//- (NSDictionary *)styleSettingDict {
//    return [self fetchAssociateValue:kAssociatedViewSettingDict];
//}
//- (void)setStyleSettingDict:(NSDictionary *)value {
//    [self setAssociateValue:value withKey:kAssociatedViewSettingDict];
//}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __original_WillMoveToWindow_Method_Imp = method_setImplementation(class_getInstanceMethod([self class],@selector(didMoveToWindow)),(IMP)__A_InjuectionDidMoveToWindow);
    });
}

void __A_InjuectionDidMoveToWindow (id self,SEL _cmd) {
    [self reloadStyle];
    ((void(*)(id,SEL))__original_WillMoveToWindow_Method_Imp)(self, _cmd);
}

- (void)reloadStyle {
    NSDictionary<NSString *, id> *setting = [self __getStyleSetting];
    if (setting) {
        [self __setupStyle:setting];
    }
    
    for (UIView *subview in [self subviews]) {
        [subview reloadStyle];
    }
}

- (UIViewController *)__findParentController {
    if ([self ParentController]) {
        return [self ParentController];
    } else {
//        NSMutableArray *hierarchy = [[NSMutableArray alloc] init];
        
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

- (NSDictionary<NSString *, id> *)__getStyleSetting {
    NSString *className = NSStringFromClass([self class]);
    NSString *key = [self styleIdentifier];
    UIViewController *parentController = [self __findParentController];
    NSString *controllerName = NSStringFromClass([parentController class]);
    
    NSMutableArray *setOfPaths = [[NSMutableArray alloc] init];
    [setOfPaths addObject:@[[NSString stringWithFormat:@"@%@", className]]];
    [setOfPaths addObject:@[@"GOBAL", [NSString stringWithFormat:@"@%@", className]]];
    
    if (key) {
        [setOfPaths addObject:@[[NSString stringWithFormat:@"#%@", key]]];
        [setOfPaths addObject:@[@"GOBAL", [NSString stringWithFormat:@"#%@", key]]];
    }
    
    if (controllerName) {
        [setOfPaths addObject:@[controllerName, [NSString stringWithFormat:@"@%@", className]]];
        if (key) {
            [setOfPaths addObject:@[controllerName, [NSString stringWithFormat:@"#%@", key]]];
        }
    }
    
    return [[A_InjuectionManager share] getStyleByKeypaths:setOfPaths];
}
- (void)__setupStyle:(NSDictionary *)setting {
    for (NSString *key in setting) {
        id itemValue = [setting objectForKey:key];
        if ([setting isColorFormat:key]) {
            itemValue = [setting convertToColor:key];
        }
        
        [self setValue:itemValue forKeyPath:key];
    }

    NSLog(@"Run setup style");
}


@end
