//
//  BLEPeripheral.m
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import "BLEPeripheral.h"


@interface BLEPeripheral()<CBPeripheralDelegate>

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, copy) DiscoverServicesResult discoverServicesResult;
@property (nonatomic, copy) DiscoverCharacteristicsResult discoverCharacteristicsResult;
@end

@implementation BLEPeripheral


+ (instancetype)Peripheral:(CBPeripheral*)peripheral
{
    BLEPeripheral *blePeripheral = [BLEPeripheral new];
    blePeripheral.peripheral = peripheral;
    return blePeripheral;
}

- (void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs result:(DiscoverServicesResult)result
{
    self.peripheral.delegate = self;
    self.discoverServicesResult = result;
    [self.peripheral discoverServices:serviceUUIDs];
}


- (void)discoverCharacteristics:(NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service result:(DiscoverCharacteristicsResult)result
{
    self.peripheral.delegate = self;
    self.discoverCharacteristicsResult = result;
    [self.peripheral discoverCharacteristics:characteristicUUIDs forService:service];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
#ifdef DEBUG
    NSLog(@"didDiscoverServices %@", error ? error.localizedFailureReason : @"success");
#endif
    if(self.discoverServicesResult){
        self.discoverServicesResult(error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error
{
#ifdef DEBUG
    NSLog(@"didDiscoverCharacteristicsForService:%@ %@", service.UUID.UUIDString, error ? error.localizedFailureReason : @"success");
#endif
    
    if(self.discoverCharacteristicsResult)
    {
        self.discoverCharacteristicsResult(error);
    }
}




@end
