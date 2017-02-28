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

typedef void (^ConnectComplete)( NSString * _Nullable error);

typedef void (^DiscoverServicesResult)(NSError * _Nullable error);
typedef void (^DiscoverCharacteristicsResult)(NSError * _Nullable error);
typedef void (^WriteCharacteristicResult)(NSError * _Nullable error);
typedef void (^ReadCharacteristicResult)(NSData* _Nullable value, NSError * _Nullable error);
typedef void (^ListenNotificationResult)(NSData* _Nullable value, NSError * _Nullable error);
typedef void (^StopNotificationResult)(NSError * _Nullable error);

@interface BLEPeripheral : NSObject

@property (nonatomic, weak,   readonly, nullable) BLEManager * bleManager;
@property (nonatomic, strong, readonly, nullable) NSString* name;
@property (nonatomic, assign, readonly)           BLEPeripheralState state;
@property (nonatomic, assign, readonly, nullable) NSUUID *identifier;
@property (nonatomic, strong, readonly, nullable) NSArray<CBService*> *services;
@property (nonatomic, strong, readonly, nullable) NSNumber *RSSI;
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSString *, id> *advertisementData;
@property (nonatomic, strong, nullable) BLEPeripheralConnectOption *connectOption;
@property (nonatomic, copy, nullable)   ConnectComplete connectComplete;



- (void)discoverServices:(nullable NSArray<CBUUID *> *)serviceUUIDs result:(nullable DiscoverServicesResult)result;

- (void)discoverCharacteristics:(nullable NSArray<CBUUID *> *)characteristicUUIDs forService:(nonnull CBService *)service result:(nullable DiscoverCharacteristicsResult)result;

- (void)writeValue:(nonnull NSData*)value forCharacteristic:(nonnull CBCharacteristic *)characteristic result:(nullable WriteCharacteristicResult)result;

- (void)readValueForCharacteristic:(nonnull CBCharacteristic *)characteristic result:(nullable ReadCharacteristicResult)result;

- (void)listenNotificationForCharacteristic:(nonnull CBCharacteristic*)characteristic result:(nullable ListenNotificationResult)result;

- (void)stopNotificationForCharacteristic:(nonnull CBCharacteristic*)characteristic result:(nullable StopNotificationResult)result;


@end
