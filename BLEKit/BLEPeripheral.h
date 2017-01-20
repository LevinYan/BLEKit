//
//  BLEPeripheral.h
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEPeripheral : NSObject

@property (nonatomic, strong) NSDictionary<NSString *, id> *advertisementData;
@property (nonatomic, strong) NSNumber *RSSI;
@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, strong, readonly) NSUUID *identifier;

+ (instancetype)Peripheral:(CBPeripheral*)peripheral;

@end
