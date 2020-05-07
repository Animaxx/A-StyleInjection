//
//  PlistStyleSourceProvider.m
//  A_StyleInjection
//
//  Created by Animax Deng on 5/6/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import "PlistStyleSourceProvider.h"

@interface PlistStyleSourceProvider()

@property (nonatomic, strong) NSString *sourceFilename;
@property (nonatomic, strong) NSBundle *sourceBundle;

@property (nonatomic, strong) NSDictionary<NSString *, id> *sourceStyleSheet;

@end

@implementation PlistStyleSourceProvider

- (instancetype)init:(NSString *)fileName {
    return [self init:fileName withBundle:[NSBundle mainBundle]];
}

- (instancetype)init:(NSString *)fileName withBundle:(NSBundle *)bundle {
    self = [super init];
    if (self) {
        self.sourceFilename = fileName;
        self.sourceBundle = bundle;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveMemoryWarning)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidReceiveMemoryWarningNotification
                                                  object:nil];
}
         
- (void)receiveMemoryWarning {
    @synchronized (self) {
        self.sourceStyleSheet = nil;
    }
}

- (NSDictionary<NSString *, id> *)getStyleByKeypaths:(NSArray<NSArray<NSString *> *> *)setOfKeyPaths {
    
    @synchronized (self) {
        if (!self.sourceStyleSheet) {
            NSString *path = [self.sourceBundle pathForResource:self.sourceFilename ofType: @"plist"];
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
            self.sourceStyleSheet = dict;
        }
    }
    
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

@end
