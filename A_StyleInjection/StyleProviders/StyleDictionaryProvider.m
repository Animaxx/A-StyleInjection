//
//  DictionaryStyleSourceProvider.m
//  A_StyleInjection
//
//  Created by Animax Deng on 5/7/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import "StyleDictionaryProvider.h"

@interface StyleDictionaryProvider()

@property (nonatomic, strong, nonnull) NSDictionary<NSString *, id> *sourceStyleSheet;

@end

@implementation StyleDictionaryProvider

- (instancetype)init: (NSDictionary<NSString *, id> *)dictionary {
    self = [super init];
    if (self) {
        self.sourceStyleSheet = dictionary;
    }
    return self;
}

- (NSDictionary<NSString *, id> *)getStyleByKeypaths:(NSArray<NSArray<NSString *> *> *)setOfKeyPaths {
    
    NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
    for (NSArray<NSString *> *itemKeyPaths in setOfKeyPaths) {
        NSDictionary *itemDict = self.sourceStyleSheet;
        for (NSString *itemkey in itemKeyPaths) {
            if (itemDict && [itemDict isKindOfClass:[NSDictionary class]]) {
                itemDict = ([itemDict objectForKey:itemkey] ? [itemDict objectForKey:itemkey] : nil);
            } else {
                itemDict = nil;
                break;
            }
        }
        
        if (itemDict) {
            [setting addEntriesFromDictionary:itemDict];
        }
    }
    
    return setting;
}

- (void)setStyle:(NSString *)styleValue toPath:(NSArray<NSString *> *)path {
    
    NSDictionary *subDic = self.sourceStyleSheet;
    
    for (NSString *keyItem in path) {
//        self.sourceStyleSheet
        if (subDic[keyItem]) {
            // TODO:
        }
    }
}

- (NSDictionary<NSString *, id> *)privodeStyleConfigForView:(NSString *)viewClass
                                                 identifier:(NSString *)viewIdentifier
                                                 controller:(NSString *)controllerName
                                                reponsePath:(NSArray<NSArray<NSString *> *> *)paths{
    return @{};
}

@end
