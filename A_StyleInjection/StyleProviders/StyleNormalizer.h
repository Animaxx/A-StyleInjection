//
//  NormalizedStyleManager.h
//  A_StyleInjection
//
//  Created by Animax Deng on 6/3/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StyleNormalizerInterface.h"

@interface StyleValueDecoder : NSObject<StyleNormalizerInterface>

- (id _Nonnull)normalize:(id _Nonnull)rawValue;
- (void)regiesterNormalizeFunc:(StyleNormalizeBlock _Nonnull)funcBlock;

@end
