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
+ (A_InjuectionManager *)share;

- (void)setStyleSourceToDict:(NSDictionary *)dict;
- (void)setStyleSourceToPlist:(NSString *)fileName;
- (void)setStyleSourceToPlist:(NSString *)fileName withBundle:(NSBundle *)bundle;

- (NSDictionary<NSString *, id> *)getNormalizedStyle:(UIView *)view;
- (NSDictionary<NSString *, id> *)getStyleByKeypaths:(NSArray<NSArray<NSString *> *> *)setOfKeyPaths;

@end
