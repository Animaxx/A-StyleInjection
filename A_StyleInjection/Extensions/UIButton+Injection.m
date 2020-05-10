//
//  UIButton+Injection.m
//  A_StyleInjection
//
//  Created by Animax Deng on 5/9/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import "UIButton+Injection.h"

@implementation UIButton (Injection)

- (NSString *)normalTitle {
    return [self titleForState:UIControlStateNormal];
}
- (void)setNormalTitle:(NSString *)val {
    [self setTitle:val forState:UIControlStateNormal];
}

- (NSString *)highlightedTitle {
    return [self titleForState:UIControlStateHighlighted];
}
- (void)setHighlightedTitle:(NSString *)val {
    [self setTitle:val forState:UIControlStateHighlighted];
}

- (NSString *)disabledTitle {
    return [self titleForState:UIControlStateDisabled];
}
- (void)setDisabledTitle:(NSString *)val {
    [self setTitle:val forState:UIControlStateDisabled];
}

- (NSString *)selectedTitle {
    return [self titleForState:UIControlStateSelected];
}
- (void)setSelectedTitle:(NSString *)val {
    [self setTitle:val forState:UIControlStateSelected];
}


- (UIColor *)normalTitleColor {
    return [self titleColorForState:UIControlStateNormal];
}
- (void)setNormalTitleColor:(UIColor *)val {
    [self setTitleColor:val forState:UIControlStateNormal];
}

- (UIColor *)highlightedTitleColor {
    return [self titleColorForState:UIControlStateHighlighted];
}
- (void)setHighlightedTitleColor:(UIColor *)val {
    [self setTitleColor:val forState:UIControlStateHighlighted];
}

- (UIColor *)disabledTitleColor {
    return [self titleColorForState:UIControlStateDisabled];
}
- (void)setDisabledTitleColor:(UIColor *)val {
    [self setTitleColor:val forState:UIControlStateDisabled];
}

- (UIColor *)selectedTitleColor {
    return [self titleColorForState:UIControlStateSelected];
}
- (void)setSelectedTitleColor:(UIColor *)val {
    [self setTitleColor:val forState:UIControlStateSelected];
}

@end
