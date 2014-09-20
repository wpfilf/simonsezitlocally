//
//  ViewController.h
//  SimonSezItLocally
//
//  Created by Wilfried on 20.09.14.
//  Copyright (c) 2014 CodeFest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeacon.h"

@interface ViewController : UIViewController

- (id)initWithBeacon:(ESTBeacon *)beacon;

@property (weak, nonatomic) IBOutlet UIImageView *purpleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *blueImageView;
@property (weak, nonatomic) IBOutlet UIImageView *greenImageView;

@end

