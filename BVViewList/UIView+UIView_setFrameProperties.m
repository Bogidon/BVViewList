//
//  UIView+UIView_setFrameProperties.m
//  ViewList
//
//  Created by Bogdan Vitoc on 5/29/14.
//  Copyright (c) 2014 Bogdan Vitoc. All rights reserved.
//

#import "UIView+UIView_setFrameProperties.h"

@implementation UIView (UIView_setFrameProperties)

- (void)setOrigin:(CGPoint)origin {
    [self setFrame:CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height)];
}

- (void)setSize:(CGSize)size {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height)];
}

- (void)setXCenter:(CGFloat)xCenter {
    [self setCenter:CGPointMake(xCenter, self.center.y)];
}

@end
