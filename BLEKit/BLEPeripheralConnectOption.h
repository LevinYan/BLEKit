//
//  BLEPeripheralConnectOption.h
//  BLEKit
//
//  Created by LevinYan on 2017/2/7.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSInteger, BLEPeripheralConnectNotifyOption) {
    
    BLEConnectPeripheralOptionNotifyNone = 0, //No notify
    BLEConnectPeripheralOptionNotifyOnConnection, //Notify when connect
    BLEConnectPeripheralOptionNotifyOnDisconnection,//Notify when disconnect
    BLEConnectPeripheralOptionNotifyOnNotification, //Notify  when receive notification
    
};

@interface BLEPeripheralConnectOption : NSObject

/*
  notify option
  Default Value: BLEConnectPeripheralOptionNotifyNone
 */
@property (nonatomic, assign) BLEPeripheralConnectNotifyOption notifyOption;

/*
    Whether to reconnect when disconnect
    Default Value: NO
 */
@property (nonatomic, assign) BOOL autoReconnect;

/*
    The time in seconds waiting for the connection complete
    if value is 0, waiting until the connection complete
    Default Value: 0
 */
@property (nonatomic, assign) float connectTimeout;

/*  
    Whether auto to discover after connection
    Default Value: YES
 */
@property (nonatomic, assign) BOOL autoDiscoverServices;

/*
    The time in seconds waiting for the discover services
    If value is 0, waiting until the connection complete
    Default Value: 0
 */
@property (nonatomic, assign) float discoverServiceTimeout;

/*
    A list of service uuids need to be discovered
    If the value is nil, all the services will be discovered
    Default Value: nil
 */
@property (nonatomic, strong) NSArray<CBUUID*> *needDiscoveredServices;

/*
    A list of characteristic uuids in the service need to be discovered
    If the value is nil, all the characteristics in the service will be discovered
    Default Value
 */
@property (nonatomic, strong) NSDictionary<CBUUID*, NSArray<CBUUID*>*> *needDiscoveredCharacteristics;

+ (instancetype)defaultOption;
@end
