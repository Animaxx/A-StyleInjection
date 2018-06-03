//
//  UIView+Injuection.h
//  A_StyleInjection
//
//  Created by Animax Deng on 5/13/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView(Injuection)

@property (nonatomic, assign) IBInspectable NSString *styleIdentifier;
@property (nonatomic, assign) UIViewController *parentController;

- (void)loadStyle:(BOOL)isReloadSubviews;
- (void)injuectStyle:(id)value tokey:(NSString *)keypath;

@end
