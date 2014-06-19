//
//  BVViewList.m
//  ViewList
//
//  Created by Bogdan Vitoc on 5/29/14.
//  Copyright (c) 2014 Bogdan Vitoc. All rights reserved.
//

#import "BVViewList.h"
#import "UIView+UIView_setFrameProperties.h"
#import <Masonry/Masonry.h>

#define TRANSITION_ANIMATION_DURATION_SECONDS 0.4

@interface BVViewList ()
@property (nonatomic) NSMutableArray *privateViews;
@property (nonatomic) NSMutableArray *titleViews;
@end

@implementation BVViewList

#pragma mark Custom intitializations
- (instancetype)init {
	self = [super init];
	if (self) {
		[self setProperties];
		self.privateViews = [[NSMutableArray alloc] init];
		self.titleViews = [[NSMutableArray alloc] init];
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
		self.titleViews = [[NSMutableArray alloc] init];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setProperties];
		self.privateViews = [[NSMutableArray alloc] init];
		self.titleViews = [[NSMutableArray alloc] init];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame views:(NSArray *)views {
	self = [super initWithFrame:frame];
	if (self) {
		[self setProperties];
		self.privateViews = [NSMutableArray arrayWithArray:views];
		self.titleViews = [[NSMutableArray alloc] init];
        
		[views enumerateObjectsUsingBlock: ^(UIView *view, NSUInteger idx, BOOL *stop) {
		    [self addSubview:view];
		    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
            

		    if (idx > 0) {
		        UIView *previousView = [self.privateViews objectAtIndex:(idx - 1)];
		        [view mas_makeConstraints: ^(MASConstraintMaker *make) {
		            if (!self.scrollDirection) {
		                make.top.equalTo(previousView.mas_bottom).with.offset(self.innerViewSpacing);
					}
		            else {
		                make.left.equalTo(previousView.mas_right).with.offset(self.innerViewSpacing);
					}
				}];
			}
		    else {
		        [view mas_makeConstraints: ^(MASConstraintMaker *make) {
		            if (!self.scrollDirection) {
		                make.top.equalTo(self.mas_top);
					}
		            else {
		                make.left.equalTo(self.mas_left);
					}
				}];
			}
            
		    [view mas_updateConstraints: ^(MASConstraintMaker *make) {
		        //Size
		        make.width.equalTo([NSNumber numberWithFloat:view.frame.size.width]);
		        make.height.equalTo([NSNumber numberWithFloat:view.frame.size.height]);
                
		        //Center
		        if (!self.scrollDirection) {
		            make.centerX.equalTo(self.mas_centerX);
				}
		        else {
		            make.centerY.equalTo(self.mas_centerY);
				}
			}];
		}];
     
        //Pin last view
		[views.lastObject mas_updateConstraints: ^(MASConstraintMaker *make) {
		    if (!self.scrollDirection) {
		        make.bottom.equalTo(self.mas_bottom);
			}
		    else {
		        make.right.equalTo(self.mas_right);
			}
		}];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame view:(UIView *)view {
	self = [super initWithFrame:frame];
	if (self) {
		[self setProperties];
		[self.privateViews addObject:view];
        
		[view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!self.scrollDirection) {
                //Position
                make.top.equalTo(self.mas_top);
                make.bottom.lessThanOrEqualTo(self.mas_top);
                
                //Center
                make.centerX.equalTo(self.mas_centerX);
            } else {
                //Position
                make.left.equalTo(self.mas_left);
                make.right.lessThanOrEqualTo(self.mas_left);
                
                //Center
                make.centerY.equalTo(self.mas_centerY);
            }
            
            //Size
            make.width.equalTo([NSNumber numberWithFloat:view.frame.size.width]);
            make.height.equalTo([NSNumber numberWithFloat:view.frame.size.height]);
        }];
        
		[self addSubview:view];
	}
	return self;
}

- (void)setProperties {
	self.showsVerticalScrollIndicator = NO;
	self.showsHorizontalScrollIndicator = NO;
	self.bouncesZoom = NO;
	self.innerViewSpacing = 20;
	self.titleIndent = 10;
	self.titleHeight = 25;
	self.titleFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
}

#pragma mark Modifying
- (void)insertViews:(NSArray *)views atIndex:(NSUInteger)idx animated:(BOOL)animated {
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
        
		[view mas_makeConstraints: ^(MASConstraintMaker *make) {
		    //Size
		    make.width.equalTo([NSNumber numberWithFloat:view.frame.size.width]);
		    make.height.equalTo([NSNumber numberWithFloat:view.frame.size.height]);
            
		    //Center
		    if (!self.scrollDirection) {
		        make.centerX.equalTo(self.mas_centerX);
			}
		    else {
		        make.centerY.equalTo(self.mas_centerY);
			}
		}];
        
		if (self.privateViews.count > idx + 1) {
			UIView *nextView = [self.privateViews objectAtIndex:idx + 1];
            
			//Next view title
			NSLayoutConstraint *constraint = [self getConstraintForFirstItem:nextView forAttribute:self.scrollDirection ? NSLayoutAttributeLeft:NSLayoutAttributeTop];
			UIView *nextViewAttachedView = constraint.secondItem;
			BOOL nextViewHasTitle = NO;
			if ([self.titleViews containsObject:nextViewAttachedView]) {
				nextViewHasTitle = YES;
			}
            
			if (idx > 0) {
				UIView *previousView = [self.privateViews objectAtIndex:idx - 1];
                
				//Pin inserted view under previous or to the right of previous depending on scroll direction
				[view mas_makeConstraints: ^(MASConstraintMaker *make) {
				    if (!self.scrollDirection) {
				        make.top.equalTo(previousView.mas_bottom).with.offset(self.innerViewSpacing);
					}
				    else {
				        make.left.equalTo(previousView.mas_right).with.offset(self.innerViewSpacing);
					}
				}];
			}
			else {
				//Pin inserted view to top or left depending on scroll direction
				[view mas_makeConstraints: ^(MASConstraintMaker *make) {
				    if (!self.scrollDirection) {
				        make.top.equalTo(self.mas_top);
					}
				    else {
				        make.left.equalTo(self.mas_left);
					}
				}];
			}
            
			//Pin next view under/to the right of inserted view
			[self layoutIfNeeded];
			[UIView animateWithDuration:animated == YES ? TRANSITION_ANIMATION_DURATION_SECONDS:0.0
			                 animations: ^{
                                 NSLayoutConstraint *constraint = [self getConstraintForFirstItem:nextViewHasTitle ? nextViewAttachedView:nextView forAttribute:self.scrollDirection ? NSLayoutAttributeLeft:NSLayoutAttributeTop];
                                 [self removeConstraint:constraint];
                                 
                                 UIView *viewToModify = nextViewHasTitle ? nextViewAttachedView : nextView;
                                 [viewToModify mas_makeConstraints: ^(MASConstraintMaker *make) {
                                     if (!self.scrollDirection) {
                                         make.top.equalTo(view.mas_bottom).with.offset(self.innerViewSpacing);
                                     }
                                     else {
                                         make.left.equalTo(view.mas_right).with.offset(self.innerViewSpacing);
                                     }
                                 }];
                                 [self layoutIfNeeded];
                             }];
		}
		else {
			if (idx > 0) {
				UIView *previousView = [self.privateViews objectAtIndex:idx - 1];
				//Unpin previous from bottom
				NSLayoutConstraint *constraint = [self getConstraintForFirstItem:previousView forAttribute:self.scrollDirection ? NSLayoutAttributeRight:NSLayoutAttributeBottom];
				[self removeConstraint:constraint];
                
				//Pin inserted view under or to the right of the previous view
				[view mas_makeConstraints: ^(MASConstraintMaker *make) {
				    if (!self.scrollDirection) {
				        make.top.equalTo(previousView.mas_bottom).with.offset(self.innerViewSpacing);
					}
				    else {
				        make.left.equalTo(previousView.mas_right).with.offset(self.innerViewSpacing);
					}
				}];
			}
			else {
				//Pin view to top or left
				[view mas_makeConstraints: ^(MASConstraintMaker *make) {
				    if (!self.scrollDirection) {
				        make.top.lessThanOrEqualTo(self.mas_top);
					}
				    else {
				        make.left.lessThanOrEqualTo(self.mas_left);
					}
				}];
			}
			//Pin view to bottom or right
			[view mas_makeConstraints: ^(MASConstraintMaker *make) {
			    if (!self.scrollDirection) {
			        make.bottom.lessThanOrEqualTo(self.mas_bottom);
				}
			    else {
			        make.right.lessThanOrEqualTo(self.mas_right);
				}
			}];
		}
		//Animate appearance
		[self layoutIfNeeded];
		[UIView animateWithDuration:animated == YES ? TRANSITION_ANIMATION_DURATION_SECONDS:0.0
		                 animations: ^{
                             view.alpha = oldAlpha;
                             [self layoutIfNeeded];
                         }];
	}
	else {
		[NSException raise:@"Out of bounds" format:@"Attempting to insert view out of bounds. Bounds are indexes 0 to %tu.", self.privateViews.count + 1];
	}
}

- (void)removeViewsAtIndexes:(NSMutableIndexSet *)indexes animated:(BOOL)animated {
	while (indexes.count > 0) {
		NSUInteger idx = [indexes firstIndex];
		[self removeViewAtIndex:idx animated:animated];
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
		                 animations: ^{
                             view.alpha = 0.0;
                             [self layoutIfNeeded];
                         }];
        
		if (self.privateViews.count > idx + 1) {
			UIView *nextView = [self.privateViews objectAtIndex:idx + 1];
            
			//Next view title
			NSLayoutConstraint *constraint = [self getConstraintForFirstItem:nextView forAttribute:NSLayoutAttributeTop];
			UIView *nextViewAttachedView = constraint.secondItem;
			BOOL nextViewHasTitle = NO;
			if ([self.titleViews containsObject:nextViewAttachedView]) {
				nextViewHasTitle = YES;
			}
            
			if (self.privateViews.count > 1 && idx > 0) {
				UIView *previousView = [self.privateViews objectAtIndex:idx - 1];
                
				//Pin next view (or next title) under previous
				[self layoutIfNeeded];
				[UIView animateWithDuration:TRANSITION_ANIMATION_DURATION_SECONDS
				                 animations: ^{
                                     UIView *viewToModify = nextViewHasTitle ? nextViewAttachedView : nextView;
                                     
                                     //If there's a title, then we're removing the constraint on the title view, which has nothing to do with scroll direction
                                     if (nextViewHasTitle && !self.scrollDirection) {
                                         NSLayoutConstraint *constraint = [self getConstraintForFirstItem:viewToModify forAttribute:NSLayoutAttributeTop];
                                         [self removeConstraint:constraint];
                                         [viewToModify mas_makeConstraints: ^(MASConstraintMaker *make) {
                                             make.top.equalTo(previousView.mas_bottom).with.offset(self.innerViewSpacing);
                                         }];
                                     }
                                     else {
                                         //There's no title, so we proceed as-is
                                         NSLayoutConstraint *constraint = [self getConstraintForFirstItem:nextView forAttribute:self.scrollDirection ? NSLayoutAttributeLeft:NSLayoutAttributeTop];
                                         [self removeConstraint:constraint];
                                         [viewToModify mas_makeConstraints: ^(MASConstraintMaker *make) {
                                             if (!self.scrollDirection) {
                                                 make.top.equalTo(previousView.mas_bottom).with.offset(self.innerViewSpacing);
                                             }
                                             else {
                                                 make.left.equalTo(previousView.mas_right).with.offset(self.innerViewSpacing);
                                             }
                                         }];
                                     }
                                     
                                     [self layoutIfNeeded];
                                 }];
			}
			else {
				//Pin next view to top of scroll view
				[self layoutIfNeeded];
				[UIView animateWithDuration:TRANSITION_ANIMATION_DURATION_SECONDS
				                 animations: ^{
                                     if (!self.scrollDirection) {
                                         //Vertical
                                         UIView *viewToModify = nextViewHasTitle ? nextViewAttachedView : nextView;
                                         NSLayoutConstraint *constraint = [self getConstraintForFirstItem:viewToModify forAttribute:self.scrollDirection ? NSLayoutAttributeLeft:NSLayoutAttributeTop];
                                         [self removeConstraint:constraint];
                                         [viewToModify mas_makeConstraints: ^(MASConstraintMaker *make) {
                                             make.top.equalTo(self.mas_top);
                                         }];
                                     }
                                     else {
                                         //Horizontal
                                         //All title views are pinned to the top in the horizontal scroll direction
                                         //So we ignore if it's a title view and just adjust the nextView
                                         NSLayoutConstraint *constraint = [self getConstraintForFirstItem:nextView forAttribute:self.scrollDirection ? NSLayoutAttributeLeft:NSLayoutAttributeTop];
                                         [self removeConstraint:constraint];
                                         
                                         [nextView mas_makeConstraints: ^(MASConstraintMaker *make) {
                                             if (!self.scrollDirection) {
                                                 make.top.equalTo(self.mas_top);
                                             }
                                             else {
                                                 make.left.equalTo(self.mas_left);
                                             }
                                         }];
                                     }
                                     
                                     [self layoutIfNeeded];
                                 }];
			}
		}
		else {
			if (self.privateViews.count > 1 && idx > 0) {
				UIView *previousView = [self.privateViews objectAtIndex:idx - 1];
                
				//Pin previous view to bottom or to the right
				NSLayoutConstraint *constraint = [self getConstraintForFirstItem:previousView forAttribute:self.scrollDirection ? NSLayoutAttributeRight:NSLayoutAttributeBottom];
				[self removeConstraint:constraint];
                
				[previousView mas_makeConstraints: ^(MASConstraintMaker *make) {
				    if (!self.scrollDirection) {
				        make.bottom.lessThanOrEqualTo(self.mas_bottom);
					}
				    else {
				        make.right.lessThanOrEqualTo(self.mas_right);
					}
				}];
			}
		}
		//Remove title
		NSLayoutConstraint *constraint = [self getConstraintForFirstItem:view forAttribute:NSLayoutAttributeTop];
		UIView *attachedView = constraint.secondItem;
		if ([self.titleViews containsObject:attachedView]) {
			[attachedView removeFromSuperview];
		}
        
		[self.privateViews removeObjectAtIndex:idx];
		[view removeFromSuperview];
	}
}

#pragma mark Titles

- (void)addTitle:(NSString *)title withBackgroundColor:(UIColor *)backgroundColor toView:(UIView *)view animated:(BOOL)animated {
	NSUInteger idx = 0;
	if ([self.privateViews containsObject:view]) {
		idx = [self.privateViews indexOfObject:view];
	}
	else {
		[NSException raise:@"Invalid view" format:@"The view does not exist in the BVViewList."];
	}
    
	UIView *titleView = [[UIView alloc] init];
	titleView.backgroundColor = backgroundColor == nil ? [UIColor lightGrayColor] : backgroundColor;
    
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.text = title;
	titleLabel.font = self.titleFont;
    
	[titleView addSubview:titleLabel];
	[titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	[titleLabel mas_makeConstraints: ^(MASConstraintMaker *make) {
	    //Size
	    make.width.equalTo(titleView.mas_width).with.offset(-self.titleIndent);
	    make.height.equalTo(titleView.mas_height);
        
	    //Positioning
	    make.top.equalTo(titleView.mas_top);
	    make.trailing.equalTo(titleView.mas_trailing);
	}];
    
	[self addSubview:titleView];
	CGFloat oldAlpha = titleView.alpha;
	titleView.alpha = 0.0;
	[titleView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[titleView mas_makeConstraints: ^(MASConstraintMaker *make) {
	    //Size
	    make.width.equalTo([NSNumber numberWithFloat:view.frame.size.width]);
	    make.height.equalTo([NSNumber numberWithFloat:self.titleHeight]);
        
	    //Center
	    make.centerX.equalTo(view.mas_centerX);
	}];
    
	//Pin bottom to view
	NSLayoutConstraint *constraint = [self getConstraintForFirstItem:view forAttribute:NSLayoutAttributeTop];
	[self removeConstraint:constraint];
	[view mas_makeConstraints: ^(MASConstraintMaker *make) {
	    make.top.equalTo(titleView.mas_bottom);
	}];
    
	if (idx > 0) {
		UIView *previousView = [self.privateViews objectAtIndex:idx - 1];
        
		//Pin to bottom/right of previous view
		[self layoutIfNeeded];
		[UIView animateWithDuration:animated == YES ? TRANSITION_ANIMATION_DURATION_SECONDS:0.0
		                 animations: ^{
                             [titleView mas_makeConstraints: ^(MASConstraintMaker *make) {
                                 make.top.equalTo(previousView.mas_bottom).with.offset(self.innerViewSpacing);
                             }];
                             [self layoutIfNeeded];
                         }];
	}
	else {
		//Pin to top
		[self layoutIfNeeded];
		[UIView animateWithDuration:animated == YES ? TRANSITION_ANIMATION_DURATION_SECONDS:0.0
		                 animations: ^{
                             [titleView mas_makeConstraints: ^(MASConstraintMaker *make) {
                                 make.top.equalTo(self.mas_top);
                             }];
                             [self layoutIfNeeded];
                         }];
	}
    
	//Animate appearance
	[self layoutIfNeeded];
	[UIView animateWithDuration:animated == YES ? TRANSITION_ANIMATION_DURATION_SECONDS:0.0
	                 animations: ^{
                         titleView.alpha = oldAlpha;
                         [self layoutIfNeeded];
                     }];
	[self.titleViews addObject:titleView];
}

#pragma mark Other
- (NSArray *)views {
	return self.privateViews;
}

- (NSLayoutConstraint *)getConstraintForFirstItem:(UIView *)view forAttribute:(NSLayoutAttribute)attribute {
	for (NSLayoutConstraint *constraint in[self constraints]) {
		if ([[constraint firstItem] isEqual:view] && [constraint firstAttribute] == attribute) {
			return constraint;
		}
	}
	return nil;
}

@end
