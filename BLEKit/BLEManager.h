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

@property (nonatomic, assign, readonly) BLEManagerState state;
@property (nonatomic, assign, readonly) BLEManagerScanState scanState;
@property (nonatomic, strong, readonly) NSMutableArray<BLEPeripheral*> *discoveredPeripherals;


+ (instancetype)shareManager;

- (void)initCentral:(InitCentralComplete)complete;

- (void)scanForPeripherals:(BLEPeripheralScanOption*)option result:(ScanResult)result;

- (void)stopScan;

- (void)connectPeripheral:(BLEPeripheral*)peripheral option:(BLEPeripheralConnectOption*)option complete:(ConnectComplete)complete;

@end
