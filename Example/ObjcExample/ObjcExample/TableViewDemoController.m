//
//  TableViewDemoController.m
//  ObjcExample
//
//  Created by Animax Deng on 5/29/18.
//  Copyright © 2018 Animax. All rights reserved.
//

#import "TableViewDemoController.h"

@interface TableViewDemoController () <UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation TableViewDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.prefetchDataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    NSLog(@"%@", indexPaths);
}


@end
