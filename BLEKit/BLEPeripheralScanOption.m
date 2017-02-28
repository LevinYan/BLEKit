//
//  BLEPeripheralScanOption.m
//  BLEKit
//
//  Created by LevinYan on 2017/2/7.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import "BLEPeripheralScanOption.h"

@implementation BLEPeripheralScanOption

+ (instancetype)defaultOption
{
    BLEPeripheralScanOption *option = [BLEPeripheralScanOption new];
    option.allowDuplicate = YES;
    option.serviceUUIDs = nil;
    return option;
}

@end
