//
//  A_InjuectionManager.h
//  A_StyleInjection
//
//  Created by Animax Deng on 5/13/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, InjuectionLoadingType) {
    InjuectionLoadingType_ViewAndProperty   = 0,
    InjuectionLoadingType_ViewOnly          = 1,
};

@interface A_InjuectionManager : NSObject

@property(nonatomic) InjuectionLoadingType loadingType;

+ (A_InjuectionManager * _Nonnull)share;

- (void)setStyleSourceToDict:(NSDictionary * _Nonnull)dict;
- (void)setStyleSourceToPlist:(NSString * _Nonnull)fileName;
- (void)setStyleSourceToPlist:(NSString * _Nonnull)fileName withBundle:(NSBundle * _Nonnull)bundle;

- (NSDictionary<NSString *, id> * _Nonnull)getNormalizedStyle:(UIView * _Nonnull)view;
- (NSDictionary<NSString *, id> * _Nonnull)getStyleByKeypaths:(NSArray<NSArray<NSString *> *> * _Nonnull)setOfKeyPaths;

@end
