//
//  TableViewCell+Injuection.m
//  A_StyleInjection
//
//  Created by Animax Deng on 5/30/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "UITableViewCell+Injuection.h"
#import "UIView+Injuection.h"

@implementation UITableViewCell(Injuection)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
}

- (void)layoutSubviews {
    NSLog(@"layout");
    [self reloadStyle];
}

@end
