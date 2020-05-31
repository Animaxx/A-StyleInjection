//
//  PrivateMethodsHeader.h
//  A_StyleInjection
//
//  Created by Animax Deng on 5/30/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView(PrivateStyleInjection)

/// Reponse path from curent to last UI View
/// return: [[className (Optional: NSNull) , styleIdentifier (Optional: NSNull)]]
- (NSArray<NSArray<NSString *> *> * _Nonnull)styleResponsePath;

/// Trace response chain and save result to `parentController` and `styleResponsePath`
- (BOOL)__traceResponseChain;

@end

// Private header functions
@interface A_StyleManager(PrivateStyleInjection)

/// Fetch style setting for appointed view
///
/// @param view Dictionary of style setting
- (NSDictionary<NSString *, id> * _Nonnull)getNormalizedStyle:(UIView * _Nonnull)view;

@end

