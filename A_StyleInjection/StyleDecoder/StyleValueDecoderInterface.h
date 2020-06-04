//
//  StyleSerializerInterface.h
//  A_StyleInjection
//
//  Created by Animax Deng on 5/8/20.
//  Copyright © 2020 Animax. All rights reserved.
//


typedef id _Nullable (^StyleValueDecodeFuncBlock)(id _Nonnull rawValue);

@protocol StyleValueDecoderInterface <NSObject>

- (id _Nullable)tryDecode:(id _Nonnull)rawValue;

@end
