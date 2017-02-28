//
//  BLEManager.m
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEManager.h"

NSString *const kBLEPeripheralConnectedNotificationKey =
@"BLEPeripheralConnectedNotificationKey";

NSString *const kBLEPeripheralDisconnectedNotificationKey =
@"BLEPeripheralDisconnectedNotificationKey";


@interface BLEPeripheral(BLEManager)

@property (nonatomic, strong) CBPeripheral *peripheral;
+ (instancetype)Peripheral:(CBPeripheral*)peripheral bleManager:(BLEManager*)bleManager;

@end


@interface BLEManager()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, assign) BLEManagerState state;
@property (nonatomic, assign) BLEManagerScanState scanState;
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
    _localConnectedPeripherals = [NSMutableArray array];
    return self;

}
- (void)initCentral:(InitCentralComplete)complete
{
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _initCentralComplete = complete;
    
}

- (NSArray<BLEPeripheral*>*)retrieveAllConnectedPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs
{
    NSArray<CBPeripheral*> *connectedPeripherals = [self.centralManager retrieveConnectedPeripheralsWithServices:serviceUUIDs];
    NSMutableArray *blePeripherals = [NSMutableArray array];
    for(CBPeripheral *p in connectedPeripherals){
        [blePeripherals addObject:[BLEPeripheral Peripheral:p bleManager:self]];
    }
    
    return [NSArray arrayWithArray:blePeripherals];
}


- (void)scanForPeripherals:(BLEPeripheralScanOption *)option result:(ScanResult)result
{
    self.scanOption = option ?: [BLEPeripheralScanOption defaultOption];
    self.scanState = BLEManagerScanWaiting;
    self.scanResult = result;
    [self checkToScan];
    
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

#if DEBUG
    NSLog(@"connectPeripheral %@", peripheral);
#endif
}

- (void)cancelConnectPeripheral:(BLEPeripheral *)peripheral
{
    [self.centralManager cancelPeripheralConnection:peripheral.peripheral];
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
        blePeripheral = [BLEPeripheral Peripheral:peripheral bleManager:self];
        [self.discoveredPeripherals addObject:blePeripheral];
    }
    [blePeripheral setValue:RSSI forKey:@"RSSI"];
    [blePeripheral setValue:advertisementData forKey:@"advertisementData"];
    if(self.scanResult)
        self.scanResult(peripheral);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
#if DEBUG
    NSLog(@"didConnectPeripheral %@", peripheral);
#endif
    BLEPeripheral *blePeripheral = [self getCacheBLEPeripheral:peripheral];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEPeripheralConnectedNotificationKey object:blePeripheral];
    [self.localConnectedPeripherals addObject:blePeripheral];
    
    BLEPeripheralConnectOption *option = blePeripheral.connectOption;
    
    __block NSString *error = nil;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if(option.autoDiscoverServices){
            
            error = @"Time Out";
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            [blePeripheral discoverServices:option.needDiscoveredServices result:^(NSError *_error) {
                error = _error.localizedFailureReason;
                dispatch_semaphore_signal(sema);
            }];
            
            dispatch_time_t timeout = option.discoverServiceTimeout ?   dispatch_time(DISPATCH_TIME_NOW, option.discoverServiceTimeout * NSEC_PER_SEC) : DISPATCH_TIME_FOREVER;
            dispatch_semaphore_wait(sema, timeout);
            
            if(!error)
            {
                for(CBService* service in blePeripheral.services){
                   
                    [blePeripheral discoverCharacteristics:option.needDiscoveredCharacteristics[service.UUID] forService:service result:^(NSError *_error) {
                       
                        error = _error.localizedFailureReason;
                        dispatch_semaphore_signal(sema);

                    }];
                    dispatch_time_t timeout = option.discoverServiceTimeout ?  dispatch_time(DISPATCH_TIME_NOW, option.discoverServiceTimeout * NSEC_PER_SEC) : DISPATCH_TIME_FOREVER;
                    dispatch_semaphore_wait(sema, timeout);
                    if(error)
                        break;
                    
                }
                
            }
            
        }
        
        ConnectComplete complete = blePeripheral.connectComplete;
        if(complete){
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(error);
            });
        }
    });
   
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
#if DEBUG
    NSLog(@"didDisconnectPeripheral %@ %@", peripheral, error ?: @"success");
#endif
    
    BLEPeripheral *blePeripheral = [self getCacheBLEPeripheral:peripheral];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBLEPeripheralDisconnectedNotificationKey object:blePeripheral];
    [self.localConnectedPeripherals removeObject:blePeripheral];


}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
#if DEBUG
    NSLog(@"didFailToConnectPeripheral %@", peripheral);
#endif
    BLEPeripheral *blePeripheral = [self getCacheBLEPeripheral:peripheral];
    ConnectComplete complete = blePeripheral.connectComplete;

    if(complete){
        complete(error.localizedFailureReason);
        blePeripheral.connectComplete = nil;
    }
}

@end
