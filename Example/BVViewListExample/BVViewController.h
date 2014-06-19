//
//  BVViewController.h
//  BVViewListExample
//
//  Created by Jai Govindani on 6/19/14.
//  Copyright (c) 2014 Jai Govindani. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BVViewList;

@interface BVViewController : UIViewController

@property (weak, nonatomic) IBOutlet BVViewList *viewList;

- (IBAction)addViewButtonTapped:(id)sender;
- (IBAction)removeViewButtonTapped:(id)sender;

@end
