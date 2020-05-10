//
//  A_InjuectionManager.h
//  A_StyleInjection
//
//  Created by Animax Deng on 5/13/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "InjectionStyleSourceRepository.h"

@interface A_StyleManager : NSObject

+ (A_StyleManager * _Nonnull)shared;
- (instancetype _Nonnull) init __attribute__((unavailable("init not available")));

/// Setup the style source repository. Style will read from the appointed repository  after setstyle but will not affected the style already applied to view
/// By default, it set to use PlistStyleSourceProvider with plist file named "StyleSheet.plist" in main bundle
///
/// @param source Style Source Repository
- (void)setupStyleSourceRepository:(id<InjectionStyleSourceRepository> _Nonnull) source;


/// Apply style setting to whole project, it will replace original style which already applied
///
/// @param window UIWindow
- (void)applyStyleToWindow:(UIWindow * _Nonnull)window;

/// Fetch style setting for appointed view
///
/// @param view Dictionary of style setting
- (NSDictionary<NSString *, id> * _Nonnull)getNormalizedStyle:(UIView * _Nonnull)view;

@end
