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

@interface A_InjuectionManager : NSObject

+ (A_InjuectionManager * _Nonnull)shared;
- (void)setStyleSourceRepository:(id<InjectionStyleSourceRepository> _Nonnull) source;

//- (void)setStyleSourceToDict:(NSDictionary * _Nonnull)dict;
//- (void)setStyleSourceToPlist:(NSString * _Nonnull)fileName;
//- (void)setStyleSourceToPlist:(NSString * _Nonnull)fileName withBundle:(NSBundle * _Nonnull)bundle;

- (NSDictionary<NSString *, id> * _Nonnull)getNormalizedStyle:(UIView * _Nonnull)view;

@end
