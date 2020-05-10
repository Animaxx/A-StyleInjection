//
//  UIButton+Injection.h
//  A_StyleInjection
//
//  Created by Animax Deng on 5/9/20.
//  Copyright © 2020 Animax. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Injection)

@property (nonatomic, assign) NSString* normalTitle;
@property (nonatomic, assign) NSString* highlightedTitle;
@property (nonatomic, assign) NSString* disabledTitle;
@property (nonatomic, assign) NSString* selectedTitle;

@property (nonatomic, assign) UIColor* normalTitleColor;
@property (nonatomic, assign) UIColor* highlightedTitleColor;
@property (nonatomic, assign) UIColor* disabledTitleColor;
@property (nonatomic, assign) UIColor* selectedTitleColor;

@end

NS_ASSUME_NONNULL_END
