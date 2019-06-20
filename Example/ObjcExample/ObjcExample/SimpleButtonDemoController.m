//
//  SimpleButtonDemoController.m
//  ObjcExample
//
//  Created by Animax Deng on 5/29/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "SimpleButtonDemoController.h"

@interface SimpleButtonDemoController ()

@property (weak, nonatomic) IBOutlet UILabel *simpleLabel;
@property (weak, nonatomic) IBOutlet UIButton *theButton;

@end

@implementation SimpleButtonDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.theButton.titleLabel setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
    [self.theButton setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forState:UIControlStateNormal];
}


@end
