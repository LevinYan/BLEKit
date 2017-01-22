//
//  BLEPeripheral.h
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void (^DiscoverServicesResult)(CBService *service, NSError *error);
typedef void (^DiscoverCharacteristicsResult)(NSError *error);


@interface BLEPeripheral : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSNumber *scanRSSI;
@property (nonatomic, strong) NSDictionary<NSString *, id> *advertisementData;


+ (instancetype)Peripheral:(CBPeripheral*)peripheral;

- (void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs result:(DiscoverServicesResult)result;
- (void)discoverCharacteristics:(NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service result:(DiscoverServicesResult)result;

@end
