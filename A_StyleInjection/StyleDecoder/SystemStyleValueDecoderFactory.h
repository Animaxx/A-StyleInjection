//
//  SystemStyleValueDecoderFactory.h
//  A_StyleInjection
//
//  Created by Animax Deng on 6/3/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StyleValueDecoderInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface SystemStyleValueDecoderFactory : NSObject

- (NSSet<id<StyleValueDecoderInterface>> *)createSystemDefaultStyleDecoders;

@end

NS_ASSUME_NONNULL_END
