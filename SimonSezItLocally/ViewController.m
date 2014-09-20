//
//  ViewController.m
//  SimonSezItLocally
//
//  Created by Wilfried on 20.09.14.
//  Copyright (c) 2014 CodeFest. All rights reserved.
//

#import "ViewController.h"

#import "ESTBeaconManager.h"

@interface ViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;

- (void)beaconManagerSetup;

@end

@implementation ViewController

- (id)initWithBeacon:(ESTBeacon *)beacon
{
    self = [super init];
    if (self)
    {
        self.beacon = beacon;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self beaconManagerSetup];

}

- (void)beaconManagerSetup {
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:self.beacon.proximityUUID
                                                                 major:[self.beacon.major unsignedIntValue]
                                                                 minor:[self.beacon.minor unsignedIntValue]
                                                            identifier:@"RegionIdentifier"];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];

}


- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    for (ESTBeacon *beacon in beacons) {
        NSLog(@"ID: %d distance: %f", beacon.color, beacon.distance)
    })
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
