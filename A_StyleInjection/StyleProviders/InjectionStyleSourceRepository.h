//
//  InjectionStyleSourceRepository.h
//  A_StyleInjection
//
//  Created by Animax Deng on 5/6/20.
//  Copyright © 2020 Animax. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol InjectionStyleSourceRepository <NSObject>

@required

/// Fetch the raw style setting from style source repository
/// Note: the raw style is not ready to set into view, need to decode by Style Value Decoder
///
/// @param viewClass class name of the view
/// @param viewIdentifier style identifier of the view
/// @param controllerName parent controller name
/// @param paths parhs [[viewClassName, Identifier]]
/// @param block Completion block returns styleSetting
- (void)privodeStyleConfigForView:(NSString * _Nonnull)viewClass
                       identifier:(NSString * _Nullable)viewIdentifier
                       controller:(NSString * _Nonnull)controllerName
                      reponsePath:(NSArray<NSArray<NSString *> *> * _Nonnull)paths
                       completion:(void (^_Nonnull)(NSDictionary<NSString *, id> * _Nonnull styleSetting))block;

@end
