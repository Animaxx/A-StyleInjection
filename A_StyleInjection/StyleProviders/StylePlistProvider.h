//
//  PlistStyleSourceProvider.h
//  A_StyleInjection
//
//  Created by Animax Deng on 5/6/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InjectionStyleSourceRepository.h"

NS_ASSUME_NONNULL_BEGIN

@interface StylePlistProvider : NSObject<InjectionStyleSourceRepository>

- (instancetype)init:(NSString *)fileName;
- (instancetype)init:(NSString *)fileName withBundle:(NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
