//
//  BLEManager.h
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEPeripheral.h"
#import "BLEPeripheralScanOption.h"
#import "BLEPeripheralConnectOption.h"

extern NSString *const kBLEPeripheralConnectedNotificationKey;
extern NSString *const kBLEPeripheralDisconnectedNotificationKey;

typedef void (^InitCentralComplete)();
typedef void (^ScanResult)(CBPeripheral *peripheral);

typedef NS_ENUM(NSInteger, BLEManagerState) {
    BLEManagerStateUnknown = 0,
    BLEManagerStateResetting,
    BLEManagerStateUnsupported,
    BLEManagerStateUnauthorized,
    BLEManagerStatePoweredOff,
    BLEManagerStatePoweredOn,
};

typedef NS_ENUM(NSUInteger, BLEManagerScanState) {
    
    BLEManagerScanStoped = 0,
    BLEManagerScanWaiting,
    BLEManagerScaning,
    
};

@interface BLEManager : NSObject

/*
    the state of the BLEManager
 */
@property (nonatomic, assign, readonly) BLEManagerState state;

/*
    the scan state of the BLEManager
 */
@property (nonatomic, assign, readonly) BLEManagerScanState scanState;

/*
    the peripherals haved been discovered by the BLEManager
 */
@property (nonatomic, strong, readonly) NSMutableArray<BLEPeripheral*> *discoveredPeripherals;

/*
 the peripherals haved been connected by the BLEManager
 */
@property (nonatomic, strong, readonly) NSMutableArray<BLEPeripheral*> *localConnectedPeripherals;

/*
    the scan option of the BLEManager
 */

@property (nonatomic, strong) BLEPeripheralScanOption *scanOption;

/*
    the singleton of the Manager
 */
+ (instancetype)shareManager;

/*
    init the manager to be a BLE central and low hardware
 */
- (void)initCentral:(InitCentralComplete)complete;

/*
    scan to discover the peripherals
    option: scan option, if nil, the default option will be use
    result: when discover the peripheral, result is called
 */
- (void)scanForPeripherals:(BLEPeripheralScanOption*)option result:(ScanResult)result;

/*
    stop scan
 */
- (void)stopScan;


/*
    Connect to the peripheral
 
    option: connect option, if nil, the default option will be use
    complete: when the connect complete or error happen, complete is called
 */
- (void)connectPeripheral:(BLEPeripheral*)peripheral option:(BLEPeripheralConnectOption*)option complete:(ConnectComplete)complete;

/*
    Disconnect to the peripheral
 
    peripheral: the specific peripheral to disconnect
 */
- (void)cancelConnectPeripheral:(BLEPeripheral*)peripheral;

/*
    Retrieve all connected peripherals,include current app and others app,even the system
 
    serviceUUIDs: A list of service UUID
    Return Value: A list of the peripherals that are currently connected to the system and that contain any of the services specified in the serviceUUID parameter
 */

- (NSArray<BLEPeripheral *> *)retrieveAllConnectedPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs;


@end
