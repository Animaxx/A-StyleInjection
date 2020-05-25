//
//  StyleChangeDemoController.m
//  ObjcExample
//
//  Created by Animax Deng on 5/18/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import "StyleChangeDemoController.h"
#import <A_StyleInjection/A_StyleInjection.h>

@interface StyleChangeDemoController ()

@end

@implementation StyleChangeDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onClick:(id)sender {
    [[A_StyleManager shared] setupStyleSourceRepository:[[StylePlistProvider alloc] init:@"StyleSheet_2"]];
    [[A_StyleManager shared] applyStyle];
}

@end
