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

- (NSDictionary<NSString *, id> * _Nonnull)getStyleByKeypaths:(NSArray<NSArray<NSString *> *> * _Nonnull)setOfKeyPaths;

@end
