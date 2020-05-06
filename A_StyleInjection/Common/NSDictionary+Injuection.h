//
//  NSDIctionary+StyleInjuection.h
//  A_StyleInjection
//
//  Created by Animax Deng on 5/18/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary(Injuection)

- (UIColor * _Nullable)convertToColor:(NSString * _Nonnull)key;
- (BOOL)isColorFormat:(NSString * _Nonnull)key;

@end
