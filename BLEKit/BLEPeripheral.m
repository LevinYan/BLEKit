//
//  BLEPeripheral.m
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import "BLEPeripheral.h"


@interface BLEPeripheral()


@end

@implementation BLEPeripheral


+ (instancetype)Peripheral:(CBPeripheral*)peripheral
{
    BLEPeripheral *blePeripheral = [BLEPeripheral new];
    blePeripheral.peripheral = peripheral;
    return blePeripheral;
}
@end
