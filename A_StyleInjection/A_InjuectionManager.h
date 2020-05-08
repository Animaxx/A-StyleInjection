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
- (NSDictionary<NSString *, id> * _Nonnull)getNormalizedStyle:(UIView * _Nonnull)view;

@end
