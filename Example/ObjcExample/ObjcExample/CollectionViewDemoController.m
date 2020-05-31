//
//  CollectionViewDemoController.m
//  ObjcExample
//
//  Created by Animax Deng on 5/29/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import "CollectionViewDemoController.h"
#import <A_StyleInjection/A_StyleInjection.h>

@interface DemoCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *input;

@end

@implementation DemoCollectionCell

@end


@interface CollectionViewDemoController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation CollectionViewDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 500;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DemoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.label setText:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    return cell;
}

- (IBAction)onClickSetStyle:(id)sender {
    [[A_StyleManager shared] setupStyleSourceRepository:[[StylePlistProvider alloc] init:@"StyleSheet"]];
}

@end
