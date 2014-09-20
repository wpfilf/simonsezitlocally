//
//  ViewController.m
//  SimonSezItLocally
//
//  Created by Wilfried on 20.09.14.
//  Copyright (c) 2014 CodeFest. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ESTBeaconManager.h"

@interface ViewController () <ESTBeaconManagerDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CLLocationManager *locationManager;

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
    
    NSLog(@"did load");
    
    [self beaconManagerSetup];
    [self setupUI];

}

- (void)beaconManagerSetup {
    
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    [self.beaconManager requestAlwaysAuthorization];
    
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:self.beacon.proximityUUID
                                                                 major:[self.beacon.major unsignedIntValue]
                                                                 minor:[self.beacon.minor unsignedIntValue]
                                                            identifier:@"RegionIdentifier"];
    
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];

}


- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    for (ESTBeacon *beacon in beacons) {
        NSLog(@"ID: %d distance: %@", beacon.color, beacon.distance);
        
        
        
    }
    
}

//- (void)setupUI {
//    
//    //add tap listeners
//    
//    UITapGestureRecognizer *blueTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(handleBlueTap:)];
//    [self.blueImageView addGestureRecognizer:blueTap];
//    
//    UITapGestureRecognizer *greenTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(handleGreenTap:)];
//    [self.greenImageView addGestureRecognizer:greenTap];
//    
//    UITapGestureRecognizer *purpleTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(handlePurpleTap:)];
//    [self.purpleImageView addGestureRecognizer:purpleTap];
//    
//}


//The event handling methods
- (void)showBlueActive {
    
    [self.blueImageView setImage:[UIImage imageNamed:@"beacon_blue_active"]];
    [self.greenImageView setImage:[UIImage imageNamed:@"beacon_green"]];
    [self.purpleImageView setImage:[UIImage imageNamed:@"beacon_purple"]];
    
}

- (void)showGreenActive {
    
    [self.greenImageView setImage:[UIImage imageNamed:@"beacon_green_active"]];
    [self.purpleImageView setImage:[UIImage imageNamed:@"beacon_purple"]];
    [self.blueImageView setImage:[UIImage imageNamed:@"beacon_blue"]];
    
}

- (void)showPurpleActive {
    
    [self.purpleImageView setImage:[UIImage imageNamed:@"beacon_purple_active"]];
    [self.blueImageView setImage:[UIImage imageNamed:@"beacon_blue"]];
    [self.greenImageView setImage:[UIImage imageNamed:@"beacon_green"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
