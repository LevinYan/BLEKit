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

/*
    allowDuplicate decide whether discover peripheral duplicately
    YES is allow discover peripheral duplicately
    NO is only discover peripheral only once
    default value is YES
 */
@property (nonatomic, assign) BOOL allowDuplicate;

/*
    If serviceUUIDs have value, the BLEManager only can discover the   peripherals advertising with any of the services specified in the serviceUUID parameter
    If nil, the BLEManager can discover all the advertising peripherasls
    default value is nil
 */
@property (nonatomic, strong) NSArray<CBUUID *> *serviceUUIDs;

+ (instancetype)defaultOption;

@end

