//
//  SystemStyleValueDecoderFactory.m
//  A_StyleInjection
//
//  Created by Animax Deng on 6/3/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import "SystemStyleValueDecoderFactory.h"
#import "DefaultStyleDecoder.h"

@implementation SystemStyleValueDecoderFactory

- (NSSet<id<StyleValueDecoderInterface>> *)createSystemDefaultStyleDecoders {
    return [[NSSet alloc] initWithArray:@[ [[DefaultStyleDecoder alloc] init] ]];
}

@end
