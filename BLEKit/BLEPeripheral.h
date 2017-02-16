//
//  BLEPeripheral.h
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEPeripheralConnectOption.h"

typedef NS_ENUM(NSInteger, BLEPeripheralState) {
    BLEPeripheralStateDisconnected = 0,
    BLEPeripheralStateConnecting,
    BLEPeripheralStateConnected,
    BLEPeripheralStateDisconnecting
};

typedef void (^ConnectComplete)(NSString *error);

typedef void (^DiscoverServicesResult)(NSError *error);
typedef void (^DiscoverCharacteristicsResult)(NSError *error);
typedef void (^WriteCharacteristicResult)(NSError *error);
typedef void (^ReadCharacteristicResult)(NSData* value, NSError *error);

@interface BLEPeripheral : NSObject

@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, assign, readonly) BLEPeripheralState state;
@property (nonatomic, assign, readonly) NSUUID *identifier;
@property (nonatomic, strong, readonly) NSArray<CBService*> *services;
@property (nonatomic, strong, readonly) NSNumber *RSSI;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *advertisementData;
@property (nonatomic, strong) BLEPeripheralConnectOption *connectOption;
@property (nonatomic, copy)   ConnectComplete connectComplete;


- (void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs result:(DiscoverServicesResult)result;
- (void)discoverCharacteristics:(NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service result:(DiscoverCharacteristicsResult)result;
- (void)writeValue:(NSData*)value forCharacteristic:(nonnull CBCharacteristic *)characteristic result:(nullable WriteCharacteristicResult)result;
- (void)readValueForCharacteristic:(nonnull CBCharacteristic *)characteristic result:(nullable ReadCharacteristicResult)result;

@end
