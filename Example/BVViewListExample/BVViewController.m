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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addViewButtonTapped:(id)sender {
    
    UIView *viewToAdd = [[UIView alloc] initWithFrame:(CGRect){.origin = CGPointZero, .size.width = self.viewList.frame.size.width,
        .size.height = arc4random() % 100 + 50}];
    UIColor *randomColor = [UIColor colorWithRed:[self random255] green:[self random255] blue:[self random255] alpha:[self random255]];
    viewToAdd.backgroundColor = randomColor;
    [self.viewList insertView:viewToAdd atIndex:0 animated:YES];
}

- (CGFloat)random255 {
    return arc4random() % 255 / 255.0f;
}

- (IBAction)removeViewButtonTapped:(id)sender {
    [self.viewList removeViewAtIndex:0 animated:YES];
}

@end
