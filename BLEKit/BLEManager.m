//
//  BLEManager.m
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEManager.h"



@interface BLEManager()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, assign) BLEManagerState state;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, copy) ScanResult scanResult;
@property (nonatomic, strong) NSMutableDictionary<NSString*, ConnectComplete> *connectCompletes;
@property (nonatomic, copy) InitCentralComplete initCentralComplete;
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
    
    _discoveredPeripherals = [NSMutableArray array];
    
    return self;

}
- (void)initCentral:(InitCentralComplete)complete
{
    
    _centralManager = [[CBCentralManager alloc] init];
    _centralManager.delegate = self;
    _initCentralComplete = complete;
    
}
- (void)scanForPeripherals:(BLEScanPeripheralOption *)option result:(ScanResult)result
{
    
    self.scanResult = result;
    [self.centralManager scanForPeripheralsWithServices:option.serviceUUIDs options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(option.allowDuplicate)}];
    
}

- (void)stopScan
{
    [self.centralManager stopScan];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral option:(BLEConnectPeripheralOption*)option complete:(void (^)(NSError *))complete
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if(option.notifyOption & BLEConnectPeripheralOptionNotifyOnConnection)
        dictionary[CBConnectPeripheralOptionNotifyOnConnectionKey] = @(YES);
    if(option.notifyOption & BLEConnectPeripheralOptionNotifyOnDisconnection)
        dictionary[CBConnectPeripheralOptionNotifyOnDisconnectionKey] = @(YES);
    if(option.notifyOption & BLEConnectPeripheralOptionNotifyOnNotification)
        dictionary[CBConnectPeripheralOptionNotifyOnNotificationKey] = @(YES);
    
    if(complete)
        self.connectCompletes[peripheral.identifier] = complete;
    
    [self.centralManager connectPeripheral:peripheral options:dictionary];

}


#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    self.state = (BLEManagerState)central.state;
    if(self.initCentralComplete)
        self.initCentralComplete();
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{

    BLEPeripheral *blePeripheral = nil;
    
    for(BLEPeripheral *p in self.discoveredPeripherals){
        if(p.peripheral == peripheral){
            blePeripheral = p;
            break;
        }
    }
    if(!blePeripheral){
        blePeripheral = [BLEPeripheral Peripheral:peripheral];
        [self.discoveredPeripherals addObject:blePeripheral];
    }
    
    blePeripheral.scanRSSI = RSSI;
    blePeripheral.advertisementData = advertisementData;
    if(self.scanResult)
        self.scanResult(peripheral);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    ConnectComplete complete = self.connectCompletes[peripheral.identifier.UUIDString];
    if(complete){
        complete(nil);
        self.connectCompletes[peripheral.identifier.UUIDString] = nil;
    }
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    ConnectComplete complete = self.connectCompletes[peripheral.identifier.UUIDString];
    if(complete){
        complete(error);
        self.connectCompletes[peripheral.identifier.UUIDString] = nil;
    }
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
}
@end
