//
//  BLEManager.m
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEManager.h"

@interface BLEManager()<CBCentralManagerDelegate>

@property (nonatomic, assign) BLEManagerState state;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, copy) void (^scanResult)(BLEPeripheral *);
@end

@implementation BLEManager

+ (instancetype)shareManager {
    static BLEManager *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[BLEManager alloc] init];
    });
    return share;
}

- (instancetype)init
{
    self = [super init];
    
    self.centralManager = [[CBCentralManager alloc] init];
    self.centralManager.delegate = self;
    
    return self;
}
- (void)scanForPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs allowDuplicates:(BOOL)allowDuplicates result:(void (^)(BLEPeripheral *))result
{
    
    [self.centralManager scanForPeripheralsWithServices:serviceUUIDs options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(allowDuplicates)}];
}

- (void)stopScan
{
    [self.centralManager stopScan];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    self.state = (BLEManagerState)central.state;
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{

    BLEPeripheral *blePeripheral = nil;
    for(BLEPeripheral *_blePeripheral in self.discoveredPeripherals){
        
        if([blePeripheral.identifier isEqual:peripheral]){
            blePeripheral = _blePeripheral;
            break;
        }
    }
    if(!blePeripheral){
        
        BLEPeripheral *blePeripheral = [BLEPeripheral Peripheral:peripheral];
        [self.discoveredPeripherals addObject:blePeripheral];
        
    }
    blePeripheral.advertisementData = advertisementData;
    blePeripheral.RSSI = RSSI;
    
    if(!self.scanResult)
        self.scanResult(blePeripheral);
}

@end
