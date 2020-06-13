//
//  DebugManager.h
//  A_StyleInjection
//
//  Created by Animax Deng on 6/8/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DebugManager : NSObject

+ (void)logError:(NSString *)message error:(NSError *)err;

@end

NS_ASSUME_NONNULL_END
