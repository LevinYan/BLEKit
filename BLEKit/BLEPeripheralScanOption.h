//
//  BLEPeripheralScanOption.h
//  BLEKit
//
//  Created by LevinYan on 2017/2/7.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEPeripheralScanOption : NSObject

@property (nonatomic, assign) BOOL allowDuplicate;
@property (nonatomic, strong) NSArray<CBUUID *> *serviceUUIDs;

+ (instancetype)defaultOption;

@end

