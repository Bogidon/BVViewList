//
//  BVViewList.h
//  ViewList
//
//  Created by Bogdan Vitoc on 5/29/14.
//  Copyright (c) 2014 Bogdan Vitoc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BVViewListScrollDirectionVertical = 0,
    BVViewListScrollDirectionHorizontal
} BVViewListScrollDirection;

@interface BVViewList : UIScrollView

@property (nonatomic, readonly) NSArray *views;
@property (nonatomic) NSInteger innerViewSpacing;
@property (nonatomic) NSInteger titleIndent;
@property (nonatomic) NSInteger titleHeight;
@property (nonatomic) UIFont *titleFont;
@property (nonatomic) BVViewListScrollDirection scrollDirection;

- (instancetype)initWithFrame:(CGRect)frame views: (NSArray *) views;
- (instancetype)initWithFrame:(CGRect)frame view: (UIView *) view;

- (void)insertViews:(NSArray *)views atIndex:(NSUInteger)idx animated:(BOOL) animated;
- (void)insertView:(UIView *)view atIndex:(NSUInteger)idx animated:(BOOL) animated;
- (void)removeViewsAtIndexes:(NSMutableIndexSet *)indexes animated:(BOOL) animated;
- (void)removeViewAtIndex:(NSUInteger)idx animated:(BOOL) animated;

- (void)addTitle:(NSString*)title withBackgroundColor:(UIColor*)backgroundColor toView:(UIView*)view animated:(BOOL)animated;
@end
