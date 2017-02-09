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

typedef void (^ConnectComplete)(NSString *error);

typedef void (^DiscoverServicesResult)(NSError *error);
typedef void (^DiscoverCharacteristicsResult)(NSError *error);


@interface BLEPeripheral : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray<CBService*> *services;
@property (nonatomic, strong) NSNumber *scanRSSI;
@property (nonatomic, strong) NSDictionary<NSString *, id> *advertisementData;
@property (nonatomic, strong) BLEPeripheralConnectOption *connectOption;
@property (nonatomic, copy) ConnectComplete connectComplete;


- (void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs result:(DiscoverServicesResult)result;
- (void)discoverCharacteristics:(NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service result:(DiscoverCharacteristicsResult)result;

@end
