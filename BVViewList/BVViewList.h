//
//  BVViewList.h
//  ViewList
//
//  Created by Bogdan Vitoc on 5/29/14.
//  Copyright (c) 2014 Bogdan Vitoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BVViewList : UIScrollView

@property (nonatomic, readonly) NSArray *views;
@property (nonatomic) NSInteger innerViewSpacing;

- (instancetype)initWithFrame:(CGRect)frame views: (NSArray *) views;
- (instancetype)initWithFrame:(CGRect)frame view: (UIView *) view;
- (void)insertViews:(NSArray *)views atIndex:(NSUInteger)idx animated:(BOOL) animated;
- (void)insertView:(UIView *)view atIndex:(NSUInteger)idx animated:(BOOL) animated;
- (void)removeViewsAtIndexes:(NSMutableIndexSet *)indexes animated:(BOOL) animated;
- (void)removeViewAtIndex:(NSUInteger)idx animated:(BOOL) animated;

@end
