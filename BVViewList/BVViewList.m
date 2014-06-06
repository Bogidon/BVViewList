//
//  BVViewList.m
//  ViewList
//
//  Created by Bogdan Vitoc on 5/29/14.
//  Copyright (c) 2014 Bogdan Vitoc. All rights reserved.
//

#import "BVViewList.h"
#import "UIView+UIView_setFrameProperties.h"

#define TRANSITION_ANIMATION_DURATION_SECONDS 0.4

@interface BVViewList ()
@property (nonatomic) NSMutableArray *privateViews;
@property (nonatomic) NSMutableArray *yPosititions;
@end

@implementation BVViewList

#pragma mark Custom intitializations
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setProperties];
        self.privateViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    // init performed by xib loading
    self = [super initWithCoder:aDecoder];
    if (self) {
        // load picker
        [self setProperties];
        self.privateViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setProperties];
        self.privateViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame views: (NSArray *) views
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setProperties];
        self.privateViews = [NSMutableArray arrayWithArray:views];
        self.yPosititions = [[NSMutableArray alloc] init];
        
        [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [self addSubview:view];
            [view setTranslatesAutoresizingMaskIntoConstraints:NO];
            if (idx > 0) {
                UIView *previousView = [self.privateViews objectAtIndex:(idx - 1)];
                [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.innerViewSpacing]];
            } else {
                [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
            }
            //Size
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:view.frame.size.width]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:view.frame.size.height]];
            //Center
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        }];
        //Pin last view
        [self addConstraint:[NSLayoutConstraint constraintWithItem:[views lastObject] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame view: (UIView *) view
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setProperties];
        [self.privateViews addObject:view];
        self.yPosititions = [[NSMutableArray alloc] initWithCapacity:1];
        
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        //Position
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        //Size
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:view.frame.size.width]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:view.frame.size.height]];
        //Center
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        
        [self addSubview:view];
    }
    return self;
}

- (void)setProperties {
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = NO;
    self.innerViewSpacing = 20;
}

#pragma mark Modifying
- (void)insertViews:(NSArray *)views atIndex:(NSUInteger)idx animated:(BOOL) animated {
    for (UIView *view in views) {
        [self insertView:view atIndex:idx animated:YES];
        idx++;
    }
}

- (void)insertView:(UIView *)view atIndex:(NSUInteger)idx animated:(BOOL)animated {
    if (self.privateViews.count >= idx) {
        [self.privateViews insertObject:view atIndex:idx];
        
        //Add view
        [self addSubview:view];
        CGFloat oldAlpha = view.alpha;
        view.alpha = 0.0;
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        //Size
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:view.frame.size.width]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:view.frame.size.height]];
        //Center
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        if (self.privateViews.count > idx+1) {
            UIView *nextView = [self.privateViews objectAtIndex:idx+1];
            if (idx > 0) {
                UIView *previousView = [self.privateViews objectAtIndex:idx-1];
                //Pin inserted view under previous
                [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.innerViewSpacing]];
            } else {
                //Pin inserted view to top
                [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
            }
            
            //Pin next view under inserted view
            [self layoutIfNeeded];
            [UIView animateWithDuration:animated == YES ? TRANSITION_ANIMATION_DURATION_SECONDS : 0.0
                             animations:^{
                                 NSLayoutConstraint *constraint = [self getConstraintForFirstItem:nextView forAttribute:NSLayoutAttributeTop];
                                 [self removeConstraint:constraint];
                                 [self addConstraint:[NSLayoutConstraint constraintWithItem:nextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.innerViewSpacing]];
                                 [self layoutIfNeeded];
                             }];
        } else {
            if (idx > 0) {
                UIView *previousView = [self.privateViews objectAtIndex:idx-1];
                //Pin inserted view under previous
                [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.innerViewSpacing]];
                //Unpin previous from bottom
                NSLayoutConstraint *constraint = [self getConstraintForFirstItem:previousView forAttribute:NSLayoutAttributeBottom];
                [self removeConstraint:constraint];
            } else {
                //Pin view to top
                [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
            }
            //Pin view to bottom
            [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        }
        //Animate appearance
        [self layoutIfNeeded];
        [UIView animateWithDuration:animated == YES ? TRANSITION_ANIMATION_DURATION_SECONDS : 0.0
                         animations:^{
                             view.alpha = oldAlpha;
                             [self layoutIfNeeded];
                         }];
    } else {
        [NSException raise:@"Out of bounds" format:@"Attempting to insert view out of bounds. Bounds are indexes 0 to %tu.", self.privateViews.count+1];
    }
}

- (void)removeViewsAtIndexes:(NSMutableIndexSet *)indexes animated:(BOOL) animated {
    while (indexes.count > 0) {
        NSUInteger idx = [indexes firstIndex];
        if (self.privateViews.count > idx) {
            UIView *view = self.privateViews[idx];
            //Make old view disappear
            [self layoutIfNeeded];
            [UIView animateWithDuration:0.4
                             animations:^{
                                 view.alpha = 0.0;
                                 [self layoutIfNeeded];
                             }];
            
            if (self.privateViews.count > idx+1) {
                UIView *nextView = [self.privateViews objectAtIndex:idx+1];
                
                if (self.privateViews.count > 1 && idx > 0) {
                    UIView *previousView = [self.privateViews objectAtIndex:idx-1];
                    
                    //Pin next view under previous
                    [self layoutIfNeeded];
                    [UIView animateWithDuration:TRANSITION_ANIMATION_DURATION_SECONDS
                                     animations:^{
                                         NSLayoutConstraint *constraint = [self getConstraintForFirstItem:nextView forAttribute:NSLayoutAttributeTop];
                                         [self removeConstraint:constraint];
                                         [self addConstraint:[NSLayoutConstraint constraintWithItem:nextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.innerViewSpacing]];
                                         [self layoutIfNeeded];
                                     }];
                } else {
                    
                    //Pin next view to top of scroll view
                    [self layoutIfNeeded];
                    [UIView animateWithDuration:TRANSITION_ANIMATION_DURATION_SECONDS
                                     animations:^{
                                         NSLayoutConstraint *constraint = [self getConstraintForFirstItem:nextView forAttribute:NSLayoutAttributeTop];
                                         [self removeConstraint:constraint];
                                         [self addConstraint:[NSLayoutConstraint constraintWithItem:nextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
                                         [self layoutIfNeeded];
                                     }];
                    
                }
            } else {
                if (self.privateViews.count > 1 && idx > 0) {
                    UIView *previousView = [self.privateViews objectAtIndex:idx-1];
                    
                    //Pin previous view to bottom
                    NSLayoutConstraint *constraint = [self getConstraintForFirstItem:previousView forAttribute:NSLayoutAttributeBottom];
                    [self removeConstraint:constraint];
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:previousView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
                }
            }
            [self.privateViews removeObjectAtIndex:idx];
            [view removeFromSuperview];
        }
        [indexes removeIndex:[indexes firstIndex]];
        [indexes shiftIndexesStartingAtIndex:0 by:-1];
    }
}

- (void)removeViewAtIndex:(NSUInteger)idx animated:(BOOL)animated {
    if (self.privateViews.count > idx) {
        UIView *view = self.privateViews[idx];
        //Make old view disappear
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.4
                         animations:^{
                             view.alpha = 0.0;
                             [self layoutIfNeeded];
                         }];
        
        if (self.privateViews.count > idx+1) {
            UIView *nextView = [self.privateViews objectAtIndex:idx+1];
            
            if (self.privateViews.count > 1 && idx > 0) {
                UIView *previousView = [self.privateViews objectAtIndex:idx-1];
                
                //Pin next view under previous
                [self layoutIfNeeded];
                [UIView animateWithDuration:TRANSITION_ANIMATION_DURATION_SECONDS
                                 animations:^{
                                     NSLayoutConstraint *constraint = [self getConstraintForFirstItem:nextView forAttribute:NSLayoutAttributeTop];
                                     [self removeConstraint:constraint];
                                     [self addConstraint:[NSLayoutConstraint constraintWithItem:nextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.innerViewSpacing]];
                                     [self layoutIfNeeded];
                                 }];
            } else {
                
                //Pin next view to top of scroll view
                [self layoutIfNeeded];
                [UIView animateWithDuration:TRANSITION_ANIMATION_DURATION_SECONDS
                                 animations:^{
                                     NSLayoutConstraint *constraint = [self getConstraintForFirstItem:nextView forAttribute:NSLayoutAttributeTop];
                                     [self removeConstraint:constraint];
                                     [self addConstraint:[NSLayoutConstraint constraintWithItem:nextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
                                     [self layoutIfNeeded];
                                 }];
                
            }
        } else {
            if (self.privateViews.count > 1 && idx > 0) {
                UIView *previousView = [self.privateViews objectAtIndex:idx-1];
                
                //Pin previous view to bottom
                NSLayoutConstraint *constraint = [self getConstraintForFirstItem:previousView forAttribute:NSLayoutAttributeBottom];
                [self removeConstraint:constraint];
                [self addConstraint:[NSLayoutConstraint constraintWithItem:previousView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
            }
        }
        [self.privateViews removeObjectAtIndex:idx];
        [view removeFromSuperview];
    }
}

#pragma mark Other
- (NSArray *)views {
    return self.privateViews;
}

- (NSLayoutConstraint *)getConstraintForFirstItem:(UIView *)view forAttribute:(NSLayoutAttribute)attribute {
    for (NSLayoutConstraint *constraint in [self constraints]) {
        if ([[constraint firstItem] isEqual:view] && [constraint firstAttribute] == attribute ) {
            return constraint;
        }
    }
    return nil;
}

@end
