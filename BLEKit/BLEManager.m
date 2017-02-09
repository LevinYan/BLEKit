//
//  BLEManager.m
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEManager.h"



@interface BLEPeripheral(BLEManager)

@property (nonatomic, strong) CBPeripheral *peripheral;
+ (instancetype)Peripheral:(CBPeripheral*)peripheral;

@end


@interface BLEManager()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, assign) BLEManagerState state;
@property (nonatomic, assign) BLEManagerScanState scanState;
@property (nonatomic, strong) BLEPeripheralScanOption *scanOption;
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, copy) ScanResult scanResult;
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
    _state = BLEManagerStateUnknown;
    _discoveredPeripherals = [NSMutableArray array];
    return self;

}
- (void)initCentral:(InitCentralComplete)complete
{
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _initCentralComplete = complete;
    
}
- (void)scanForPeripherals:(BLEPeripheralScanOption *)option result:(ScanResult)result
{
    self.scanState = BLEManagerScanWaiting;
    self.scanResult = result;
    
}
- (void)checkToScan
{
    if(self.state == BLEManagerStatePoweredOn && self.scanState == BLEManagerScanWaiting){
        [self.centralManager scanForPeripheralsWithServices:self.scanOption.serviceUUIDs options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(self.scanOption.allowDuplicate)}];
        self.scanState = BLEManagerScaning;
        return;
    }

}

- (void)stopScan
{
    [self.centralManager stopScan];
    self.scanState = BLEManagerScanStoped;
}

- (void)connectPeripheral:(BLEPeripheral *)peripheral option:(BLEPeripheralConnectOption*)option complete:(void (^)(NSString *))complete
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if(option.notifyOption & BLEConnectPeripheralOptionNotifyOnConnection)
        dictionary[CBConnectPeripheralOptionNotifyOnConnectionKey] = @(YES);
    if(option.notifyOption & BLEConnectPeripheralOptionNotifyOnDisconnection)
        dictionary[CBConnectPeripheralOptionNotifyOnDisconnectionKey] = @(YES);
    if(option.notifyOption & BLEConnectPeripheralOptionNotifyOnNotification)
        dictionary[CBConnectPeripheralOptionNotifyOnNotificationKey] = @(YES);
    
    peripheral.connectOption = option;
    peripheral.connectComplete = complete;
    
    [self.centralManager connectPeripheral:peripheral.peripheral options:dictionary];

}

- (BLEPeripheral*)getCacheBLEPeripheral:(CBPeripheral*)peripheral
{
    __block BLEPeripheral *blePeripheral = nil;
    [self.discoveredPeripherals enumerateObjectsUsingBlock:^(BLEPeripheral * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(obj.peripheral == peripheral){
            blePeripheral = obj;
            *stop = YES;
        }
    }];
    return blePeripheral;
    
}
- (void)cacheBLEPeripheral:(BLEPeripheral*)blePeripheral
{
    [self.discoveredPeripherals addObject:blePeripheral];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    self.state = (BLEManagerState)central.state;
    if(self.initCentralComplete)
        self.initCentralComplete();
    
    [self checkToScan];
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{

    BLEPeripheral *blePeripheral = [self getCacheBLEPeripheral:peripheral];
    
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
    BLEPeripheral *blePeripheral = [self getCacheBLEPeripheral:peripheral];
    BLEPeripheralConnectOption *option = blePeripheral.connectOption;
    
    __block NSString *error = nil;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if(option.autoDiscoverServices){
            
            error = @"Time Out";
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            [blePeripheral discoverServices:option.services result:^(NSError *_error) {
                error = _error.localizedFailureReason;
                dispatch_semaphore_signal(sema);
            }];
            
            dispatch_time_t timeout = option.discoverServiceTimeout ? DISPATCH_TIME_FOREVER : dispatch_time(DISPATCH_TIME_NOW, option.discoverServiceTimeout * NSEC_PER_SEC) ;
            dispatch_semaphore_wait(sema, timeout);
            
            if(!error)
            {
                for(CBService* service in blePeripheral.services){
                    [blePeripheral discoverCharacteristics:option.characteristics[service.UUID] forService:service result:^(NSError *_error) {
                       
                        error = _error.localizedFailureReason;
                        dispatch_semaphore_signal(sema);

                    }];
                    dispatch_time_t timeout = option.discoverServiceTimeout ? DISPATCH_TIME_FOREVER : dispatch_time(DISPATCH_TIME_NOW, option.discoverServiceTimeout * NSEC_PER_SEC) ;
                    dispatch_semaphore_wait(sema, timeout);
                    if(!error)
                        break;
                    
                }
                
            }
            
        }
        
        ConnectComplete complete = blePeripheral.connectComplete;
        if(complete){
            complete(error);
        }
    });
   
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    BLEPeripheral *blePeripheral = [self getCacheBLEPeripheral:peripheral];
    ConnectComplete complete = blePeripheral.connectComplete;

    if(complete){
        complete(error.localizedFailureReason);
        blePeripheral.connectComplete = nil;
    }
}

@end
