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

/*
    The manager managing the peripheral
 */
@property (nonatomic, weak,   readonly, nullable) BLEManager * bleManager;

/*
    The name of the peripheral
 */
@property (nonatomic, strong, readonly, nullable) NSString* name;

/*
    The state of the peripheral
 */
@property (nonatomic, assign, readonly)           BLEPeripheralState state;

/*
    The identifier of the peripheral
 */
@property (nonatomic, assign, readonly, nullable) NSUUID *identifier;

/*
    The services of the peripheral
 */
@property (nonatomic, strong, readonly, nullable) NSArray<CBService*> *services;

/*
    The RSSI of the RSSI of the peripheral
 */
@property (nonatomic, strong, readonly, nullable) NSNumber *RSSI;

/*
    The advertising data of the peripheral
 */
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSString *, id> *advertisementData;

/*
    The connect option of the periheral
 */
@property (nonatomic, strong, nullable) BLEPeripheralConnectOption *connectOption;



/*
    Discover services
 
    serviceUUIDs: A list of service uuids need to be discovered,
    If the value is nil, all the services will be discovered
 
    result: called when service discover complete or error happen, check the error parameter
 
 */

- (void)discoverServices:(nullable NSArray<CBUUID *> *)serviceUUIDs result:(nullable DiscoverServicesResult)result;


/*
 Discover the characteristics for the specific service
 
 characteristicUUIDs: A list of characteristic uuids need to be discovered,
 If the value is nil, all the characteristics in the specific service will be discovered
 
 service: the specific service
 
 result: called when the characteristics discover complete or error happen, when success error is nil
 
 */
- (void)discoverCharacteristics:(nullable NSArray<CBUUID *> *)characteristicUUIDs forService:(nonnull CBService *)service result:(nullable DiscoverCharacteristicsResult)result;

/*
    Write the value for the specific characteristic
 
    value: The value to be written
 
    characteristic: The specific characteristic to write the value
 
    result: called when write complete or error happen, when success error is nil
 */
- (void)writeValue:(nonnull NSData*)value forCharacteristic:(nonnull CBCharacteristic *)characteristic result:(nullable WriteCharacteristicResult)result;


/*
 Read the value for the specific characteristic
 
 
 characteristic: The specific characteristic to read the value
 
 result: called when read complete or error happen, when success error is nil and value is the read data
 */
- (void)readValueForCharacteristic:(nonnull CBCharacteristic *)characteristic result:(nullable ReadCharacteristicResult)result;


/*
 Enable and listen the notification for specific characteristic
 
 characteristic: The specific characteristic's notification to be listened
 
 result: called when notification come or error happen, when success error is nil and value is the notification data
 */
- (void)listenNotificationForCharacteristic:(nonnull CBCharacteristic*)characteristic result:(nullable ListenNotificationResult)result;

/*
 Disable the notification for specific characteristic
 
 characteristic: The specific characteristic's notification to stop
 
 result: called when disable notification complete, when success error is nil
 */
- (void)stopNotificationForCharacteristic:(nonnull CBCharacteristic*)characteristic result:(nullable StopNotificationResult)result;


@end
