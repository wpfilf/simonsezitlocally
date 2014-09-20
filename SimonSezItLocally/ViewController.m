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
#import "GameUtils.h"
#import <AudioToolbox/AudioServices.h>

@interface ViewController () <ESTBeaconManagerDelegate,CLLocationManagerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic) short stepNumber;
@property (nonatomic,strong) NSArray *sequence;
@property (nonatomic) short currentBeaconColor;

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
    
    [self startGame];
    
    
}

- (void)startGame {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.currentBeaconColor = -1;
    
    self.stepNumber = 0;
    self.sequence = [GameUtils generateGameColorSeq:3];
    
    //show sequence
    
    float t = 0.0;
    
    for (NSNumber *n in self.sequence) {
        
        switch ([n intValue]) {
            case ESTBeaconColorBlueberry:
                [self performSelector:@selector(showBlueBerryActive) withObject:self afterDelay:t ];
                
                break;
                
            case ESTBeaconColorMint:
                [self performSelector:@selector(showMintActive) withObject:self afterDelay:t ];
                break;
                
            case ESTBeaconColorIce:
                [self performSelector:@selector(showIceActive) withObject:self afterDelay:t ];
                
                break;
                
            default:
                break;
        }
        
        t++;
        
    }
    
    [self performSelector:@selector(beaconManagerSetup) withObject:self afterDelay:t];
    
}

- (void)beaconManagerSetup {
    
    [self resetActives];
    
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
        
        if (self.currentBeaconColor == -1) {
           
            if ([self isClosestBeacon:[beacon.distance floatValue]]){
                
                AudioServicesPlaySystemSound (1104);
                self.view.backgroundColor = [UIColor whiteColor];
                
                self.currentBeaconColor = beacon.color;
                
                if ([self checkCurrentStep:beacon.color]) {
                    
                    self.view.backgroundColor = [UIColor greenColor];
                    
                    if (self.stepNumber == self.sequence.count-1) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SImon Sez"
                                                                        message:@"YOU DID IT!"
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                    }
                    
                    
                }else{
                    
                    self.view.backgroundColor = [UIColor redColor];
                    
                }
                
                self.stepNumber++;
                
            }

            
            
        }else{
            
            if (self.currentBeaconColor == beacon.color) {
                
                if ([beacon.distance floatValue] > 0.1) {
                    self.currentBeaconColor = -1;
                    self.view.backgroundColor = [UIColor whiteColor];
                }
                
            }
            
            
        }
        
        
    }
    
}

- (BOOL)isClosestBeacon:(float)distance {
    
    if (distance < 0.025){
        return true;
    }else {
        return false;

    }
    
}

- (BOOL)checkCurrentStep:(ESTBeaconColor)color {
    
    if (self.stepNumber < self.sequence.count) {
        NSNumber *c = [self.sequence objectAtIndex:self.stepNumber];
        
        if (color == [c intValue]) {
            //COOL
            return true;
        }else{
            //WRONG
            return false;
        }
    }
    return false;
}


//The event handling methods
- (void)showIceActive {
    
    [self.blueImageView setImage:[UIImage imageNamed:@"beacon_blue_active"]];
    [self.greenImageView setImage:[UIImage imageNamed:@"beacon_green"]];
    [self.purpleImageView setImage:[UIImage imageNamed:@"beacon_purple"]];
    
}

- (void)showMintActive {
    
    [self.greenImageView setImage:[UIImage imageNamed:@"beacon_green_active"]];
    [self.purpleImageView setImage:[UIImage imageNamed:@"beacon_purple"]];
    [self.blueImageView setImage:[UIImage imageNamed:@"beacon_blue"]];
    
}

- (void)showBlueBerryActive {
    
    [self.purpleImageView setImage:[UIImage imageNamed:@"beacon_purple_active"]];
    [self.blueImageView setImage:[UIImage imageNamed:@"beacon_blue"]];
    [self.greenImageView setImage:[UIImage imageNamed:@"beacon_green"]];
}

- (void)resetActives {
    [self.purpleImageView setImage:[UIImage imageNamed:@"beacon_purple"]];
    [self.blueImageView setImage:[UIImage imageNamed:@"beacon_blue"]];
    [self.greenImageView setImage:[UIImage imageNamed:@"beacon_green"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
        [self startGame];
    }
}

@end
