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
    
    BLEConnectPeripheralOptionNotifyNone = 0,
    BLEConnectPeripheralOptionNotifyOnConnection,
    BLEConnectPeripheralOptionNotifyOnDisconnection,
    BLEConnectPeripheralOptionNotifyOnNotification,
    
};

@interface BLEPeripheralConnectOption : NSObject

@property (nonatomic, assign) BLEPeripheralConnectNotifyOption notifyOption;
@property (nonatomic, assign) float connectTimeout;
@property (nonatomic, assign) float discoverServiceTimeout;
@property (nonatomic, assign) BOOL autoDiscoverServices;
@property (nonatomic, strong) NSArray<CBUUID*> *services;
@property (nonatomic, strong) NSDictionary<CBUUID*, NSArray<CBUUID*>*> *characteristics;

@end
