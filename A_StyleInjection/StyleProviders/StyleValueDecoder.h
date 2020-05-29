//
//  NormalizedStyleManager.h
//  A_StyleInjection
//
//  Created by Animax Deng on 6/3/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StyleValueDecoderInterface.h"

@interface StyleValueDecoder : NSObject<StyleValueDecoderInterface>

- (id _Nonnull)decode:(id _Nonnull)rawValue;
- (void)regiesterValueDecodeFunc:(StyleValueDecodeFuncBlock _Nonnull)funcBlock;

@end
