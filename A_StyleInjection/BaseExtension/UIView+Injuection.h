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

@property (nonatomic, assign, nullable) IBInspectable  NSString *styleIdentifier;
@property (nonatomic, assign, nullable) UIViewController *parentController;

@property (nonatomic, readonly) BOOL isStyleApplied;

- (void)loadStyle:(BOOL)isReloadSubviews forceReload:(BOOL)forceReload;
- (void)injuectStyle:(id _Nonnull)value tokey:(NSString * _Nonnull)keypath;

@end
