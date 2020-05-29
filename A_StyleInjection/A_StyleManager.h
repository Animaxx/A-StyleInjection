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
#import "StyleValueDecoderInterface.h"

@interface A_StyleManager : NSObject

+ (A_StyleManager * _Nonnull)shared;

- (instancetype _Nonnull) init __attribute__((unavailable("init not available")));

/// Setup the style source repository. Style will read from the appointed repository  after setstyle but will not affected the style already applied to view
/// By default, it set to use PlistStyleSourceProvider with plist file named "StyleSheet.plist" in main bundle
///
/// @param source Style Source Repository
- (void)setupStyleSourceRepository:(id<InjectionStyleSourceRepository> _Nonnull) source;

/// Register style value decoding function
///
/// @param block function closure
- (void)registerValueDecodeFunc:(StyleNormalizeBlock _Nonnull)block;

/// Apply and force refresh the style setting to whole window, it will replace original style if already applied
///
/// @param window UIWindow
- (void)applyStyleInWindow:(UIWindow * _Nonnull)window;

/// Apply and force refresh the style setting to key window, it will replace original style if already applied
- (void)applyStyle;


@end

// Private header functions
@interface A_StyleManager()

/// Fetch style setting for appointed view
///
/// @param view Dictionary of style setting
- (NSDictionary<NSString *, id> * _Nonnull)getNormalizedStyle:(UIView * _Nonnull)view;

@end
