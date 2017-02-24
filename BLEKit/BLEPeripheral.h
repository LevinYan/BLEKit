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

@class BLEManager;

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
typedef void (^ListenNotificationResult)(NSData* value, NSError *error);
typedef void (^StopNotificationResult)(NSError *error);

@interface BLEPeripheral : NSObject

@property (nonatomic, weak,   readonly) BLEManager *bleManager;
@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, assign, readonly) BLEPeripheralState state;
@property (nonatomic, assign, readonly) NSUUID *identifier;
@property (nonatomic, strong, readonly) NSArray<CBService*> *services;
@property (nonatomic, strong, readonly) NSNumber *RSSI;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *advertisementData;
@property (nonatomic, strong) BLEPeripheralConnectOption *connectOption;
@property (nonatomic, copy)   ConnectComplete connectComplete;

- (void)connectWithOption:(nullable BLEPeripheralConnectOption*)option complete:(nullable ConnectComplete)complete;

- (void)discoverServices:(nullable NSArray<CBUUID *> *)serviceUUIDs result:(nullable DiscoverServicesResult)result;

- (void)discoverCharacteristics:(nullable NSArray<CBUUID *> *)characteristicUUIDs forService:(nonnull CBService *)service result:(nullable DiscoverCharacteristicsResult)result;

- (void)writeValue:(nonnull NSData*)value forCharacteristic:(nonnull CBCharacteristic *)characteristic result:(nullable WriteCharacteristicResult)result;

- (void)readValueForCharacteristic:(nonnull CBCharacteristic *)characteristic result:(nullable ReadCharacteristicResult)result;

- (void)listenNotificationForCharacteristic:(nonnull CBCharacteristic*)characteristic result:(nullable ListenNotificationResult)result;

- (void)stopNotificationForCharacteristic:(nonnull CBCharacteristic*)characteristic result:(nullable StopNotificationResult)result;


@end
