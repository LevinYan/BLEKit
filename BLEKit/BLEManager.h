//
//  BLEManager.h
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEPeripheral.h"

typedef NS_ENUM(NSInteger, BLEManagerState) {
    BLEManagerStateUnknown = 0,
    BLEManagerStateResetting,
    BLEManagerStateUnsupported,
    BLEManagerStateUnauthorized,
    BLEManagerStatePoweredOff,
    BLEManagerStatePoweredOn,
};


@interface BLEManager : NSObject

@property (nonatomic, assign, readonly) BLEManagerState state;
@property (nonatomic, strong, readonly) NSMutableArray<BLEPeripheral*> *discoveredPeripherals;


+ (instancetype)shareManager;

- (void)scanForPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs
                       allowDuplicates:(BOOL)allowDuplicates
                                result:(void (^)(BLEPeripheral *peripheral))result;
- (void)stopScan;
@end
