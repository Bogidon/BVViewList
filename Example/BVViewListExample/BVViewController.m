//
//  BVViewController.m
//  BVViewListExample
//
//  Created by Jai Govindani on 6/19/14.
//  Copyright (c) 2014 Jai Govindani. All rights reserved.
//

#import "BVViewController.h"
#import <BVViewList/BVViewList.h>

@interface BVViewController ()

@end

@implementation BVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.viewList.scrollDirection = BVViewListScrollDirectionHorizontal;
    self.viewList.bounces = YES;
    
    if (self.viewList.scrollDirection == BVViewListScrollDirectionVertical) {
        self.viewList.alwaysBounceVertical = YES;
    } else {
        self.viewList.alwaysBounceHorizontal = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    BVViewList *viewList = [[BVViewList alloc] initWithFrame:self.view.frame view:[self randomView]];
//    self.viewList = viewList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addViewButtonTapped:(id)sender {
    
    UIView *viewToAdd = [self randomView];
    [self.viewList insertView:viewToAdd atIndex:0 animated:YES];
    [self.viewList addTitle:@"hello" withBackgroundColor:nil toView:viewToAdd animated:YES];
}

- (UIView*)randomView {
    
    CGFloat width, height;
    if (self.viewList.scrollDirection == BVViewListScrollDirectionVertical) {
        width = self.viewList.frame.size.width;
        height = arc4random() % 100 + 50;
    } else {
        width = arc4random() % 50 + 50;
        height = self.viewList.frame.size.height;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){.origin = CGPointZero, .size.width = width, .size.height = height}];
    UIColor *randomColor = [UIColor colorWithRed:[self random255] green:[self random255] blue:[self random255] alpha:[self random255]];
    view.backgroundColor = randomColor;
    return view;
}

- (CGFloat)random255 {
    return arc4random() % 255 / 255.0f;
}

- (IBAction)removeViewButtonTapped:(id)sender {
    [self.viewList removeViewAtIndex:0 animated:YES];
}

@end
