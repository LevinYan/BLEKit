//
//  BLEPeripheralConnectOption.m
//  BLEKit
//
//  Created by LevinYan on 2017/2/7.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import "BLEPeripheralConnectOption.h"

@implementation BLEPeripheralConnectOption

+ (instancetype)defaultOption
{
    BLEPeripheralConnectOption *option = [[[self class] alloc] init];
    option.notifyOption = BLEConnectPeripheralOptionNotifyNone;
    option.connectTimeout = 0;
    option.autoDiscoverServices = YES;
    option.needDiscoveredServices = nil;
    option.needDiscoveredCharacteristics = nil;
    option.autoReconnect = NO;
    return option;
}
@end
