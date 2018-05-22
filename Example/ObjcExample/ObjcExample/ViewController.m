//
//  ViewController.m
//  ObjcExample
//
//  Created by Animax Deng on 4/27/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "ViewController.h"
#import <A_StyleInjection/A_StyleInjection.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.demoButton1.styleIdentifier = @"demo1";
    NSLog(@"%@", self.demoButton1.styleIdentifier);
    
//    self.demoButton1.layer.cornerRadius = 10.0;
//    [self.demoButton1 setBackgroundColor:[UIColor redColor]];
    
//    [self.demoButton1 setValue:@(50.0) forKeyPath:@"layer.cornerRadius"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"View will appear");
}


@end
