//
//  BLEManager.h
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEPeripheral.h"


typedef void (^InitCentralComplete)();
typedef void (^ScanResult)(CBPeripheral *peripheral);
typedef void (^ConnectComplete)(NSError *error);

typedef NS_ENUM(NSInteger, BLEManagerState) {
    BLEManagerStateUnknown = 0,
    BLEManagerStateResetting,
    BLEManagerStateUnsupported,
    BLEManagerStateUnauthorized,
    BLEManagerStatePoweredOff,
    BLEManagerStatePoweredOn,
};

typedef NS_ENUM(NSInteger, BLEConnectPeripheralNotifyOption) {
    
    BLEConnectPeripheralOptionNotifyNone = 0,
    BLEConnectPeripheralOptionNotifyOnConnection,
    BLEConnectPeripheralOptionNotifyOnDisconnection,
    BLEConnectPeripheralOptionNotifyOnNotification,

};

@interface BLEScanPeripheralOption : NSObject

@property (nonatomic, assign) BOOL allowDuplicate;
@property (nonatomic, strong) NSArray<CBUUID *> *serviceUUIDs;

@end

@interface BLEConnectPeripheralOption : NSObject

@property (nonatomic, assign) BLEConnectPeripheralNotifyOption notifyOption;
@property (nonatomic, assign) BOOL autoDiscoverServices;
@property (nonatomic, strong) NSArray<CBUUID*> *services;
@property (nonatomic, strong) NSDictionary<CBUUID*, NSArray<CBUUID*>*> *characteristics;

@end



@interface BLEManager : NSObject

@property (nonatomic, assign, readonly) BLEManagerState state;
@property (nonatomic, strong, readonly) NSMutableArray<BLEPeripheral*> *discoveredPeripherals;


+ (instancetype)shareManager;

- (void)initCentral:(InitCentralComplete)complete;

- (void)scanForPeripherals:(BLEScanPeripheralOption*)option result:(ScanResult)result;

- (void)stopScan;

- (void)connectPeripheral:(BLEPeripheral*)peripheral option:(BLEConnectPeripheralOption*)option complete:(ConnectComplete)complete;

@end
