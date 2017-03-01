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
    The time duration for scan, when the time reach, scan will be stoped
    If the value is 0, scan forever until the stopScan is called
    Defult Value: 0
 */
@property (nonatomic, assign) float timeout;

/*
    allowDuplicate decide whether discover peripheral duplicately
    YES is allow discover peripheral duplicately
    NO is only discover peripheral only once
    Default Value: YES
 */
@property (nonatomic, assign) BOOL allowDuplicate;

/*
    If serviceUUIDs have value, the BLEManager only can discover the   peripherals advertising with any of the services specified in the serviceUUID parameter
    If nil, the BLEManager can discover all the advertising peripherasls
    Default Value: nil
 */
@property (nonatomic, strong) NSArray<CBUUID *> *serviceUUIDs;

+ (instancetype)defaultOption;

@end

