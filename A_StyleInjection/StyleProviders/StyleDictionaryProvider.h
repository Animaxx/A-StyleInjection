//
//  DictionaryStyleSourceProvider.h
//  A_StyleInjection
//
//  Created by Animax Deng on 5/7/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InjectionStyleSourceRepository.h"

NS_ASSUME_NONNULL_BEGIN

@interface StyleDictionaryProvider : NSObject<InjectionStyleSourceRepository>

- (instancetype)init:(NSDictionary<NSString *, id> *)styleDictionary;
- (void)setStyle:(NSString *)styleValue toPath:(NSArray<NSString *> *)path;

@end

NS_ASSUME_NONNULL_END
