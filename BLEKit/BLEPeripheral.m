//
//  BLEPeripheral.m
//  BLEKit
//
//  Created by LevinYan on 2017/1/19.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import "BLEManager.h"
#import "BLEPeripheral.h"



@interface BLEManager(BLEPeripheral)

- (void)connectPeripheral:(BLEPeripheral*)peripheral option:(BLEPeripheralConnectOption*)option complete:(ConnectComplete)complete;

@end

@interface BLEPeripheral()<CBPeripheralDelegate>

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) BLEPeripheralState state;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, copy) DiscoverServicesResult discoverServicesResult;
@property (nonatomic, copy) DiscoverCharacteristicsResult discoverCharacteristicsResult;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableArray<WriteCharacteristicResult>*> *writeCharacteristicResults;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableArray<ReadCharacteristicResult>*> *readCharacteristicResults;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableArray<ListenNotificationResult>*> *listenNotificationResults;
@property (nonatomic, copy) NSMutableDictionary<NSString*, StopNotificationResult>*stopNotifcationResults;

@end

@implementation BLEPeripheral


+ (instancetype)Peripheral:(CBPeripheral*)peripheral bleManager:(BLEManager*)bleManager
{
    BLEPeripheral *blePeripheral = [BLEPeripheral new];

    [blePeripheral init:peripheral bleManager:bleManager];
    return blePeripheral;
}

- (void)init:(CBPeripheral*)peripheral bleManager:(BLEManager*)bleManager
{
    _bleManager = bleManager;
    _peripheral = peripheral;
    [_peripheral addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    [_peripheral addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    
}




- (void)connectWithOption:(BLEPeripheralConnectOption *)option complete:(ConnectComplete)complete
{
    [self.bleManager connectPeripheral:self option:option complete:complete];
}
- (NSArray<CBService*>*)services
{
    return self.peripheral.services;
}

- (NSUUID*)identifier
{
    return self.peripheral.identifier;
}

- (void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs result:(DiscoverServicesResult)result
{
#ifdef DEBUG
    NSLog(@"peripheral %@ discoverServices", self.peripheral);
#endif
    self.peripheral.delegate = self;
    self.discoverServicesResult = result;
    [self.peripheral discoverServices:serviceUUIDs];
}


- (void)discoverCharacteristics:(NSArray<CBUUID *> *)characteristicUUIDs forService:(CBService *)service result:(DiscoverCharacteristicsResult)result
{
#ifdef DEBUG
    NSLog(@"peripheral %@ discoverCharacteristicsForService %@", self.peripheral, service);
#endif
    
    self.peripheral.delegate = self;
    self.discoverCharacteristicsResult = result;
    [self.peripheral discoverCharacteristics:characteristicUUIDs forService:service];
}

- (void)writeValue:(NSData *)value forCharacteristic:(CBCharacteristic *)characteristic result:(WriteCharacteristicResult)result
{
#ifdef DEBUG
    NSLog(@"peripheral %@, writeValue %@ forCharacteristic %@", self.peripheral, value, characteristic.UUID.UUIDString);
#endif
    if(result && (characteristic.properties & CBCharacteristicPropertyWrite)){
        
        [[self getWriteCharacteristicResults:characteristic] addObject:result];
        [self.peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }else{
        [self.peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        if(result)
            result(nil);
    }
}

- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic result:(ReadCharacteristicResult)result
{
#ifdef DEBUG
    NSLog(@"peripheral %@ readValueForCharacteristic %@", self.peripheral, characteristic.UUID.UUIDString);
#endif
    
    if(result)
        [[self getReadCharacteristicResults:characteristic] addObject:result];
    
    [self.peripheral readValueForCharacteristic:characteristic];
}


- (void)listenNotificationForCharacteristic:(CBCharacteristic *)characteristic result:(ListenNotificationResult)result
{
    [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];

}

- (void)stopNotificationForCharacteristic:(CBCharacteristic *)characteristic result:(StopNotificationResult)result
{
    self.stopNotifcationResults[characteristic.UUID.UUIDString] = result;
    [self.peripheral setNotifyValue:NO forCharacteristic:characteristic];
    [[self getListenNotificationResults:characteristic] removeAllObjects];
}

- (NSMutableArray<ReadCharacteristicResult>*)getReadCharacteristicResults:(CBCharacteristic*)characteristic
{

    if(!_readCharacteristicResults)
        _readCharacteristicResults = [NSMutableDictionary dictionary];
    
    NSMutableArray<ReadCharacteristicResult>* results = self.readCharacteristicResults[characteristic.UUID.UUIDString];
    if(!results){
        results = [NSMutableArray array];
        self.readCharacteristicResults[characteristic.UUID.UUIDString] = results;
    }
    return results;
}
- (NSMutableArray<WriteCharacteristicResult>*)getWriteCharacteristicResults:(CBCharacteristic*)characteristic
{
    if(_writeCharacteristicResults)
        _writeCharacteristicResults = [NSMutableDictionary dictionary];

    NSMutableArray<WriteCharacteristicResult>* results = self.writeCharacteristicResults[characteristic.UUID.UUIDString];
    if(!results){
        results = [NSMutableArray array];
        self.writeCharacteristicResults[characteristic.UUID.UUIDString] = results;
    }
    return results;
}

- (NSMutableArray<ListenNotificationResult>*)getListenNotificationResults:(CBCharacteristic*)characteristic
{
    if(_listenNotificationResults)
        _listenNotificationResults = [NSMutableDictionary dictionary];
    
     NSMutableArray<ListenNotificationResult>* results = self.listenNotificationResults[characteristic.UUID.UUIDString];
    if(!results){
        results = [NSMutableArray array];
        self.listenNotificationResults[characteristic.UUID.UUIDString] = results;
    }
    return results;
}

- (NSMutableDictionary<NSString*, StopNotificationResult>*)stopNotifcationResults
{
    if(!_stopNotifcationResults)
        _stopNotifcationResults = [NSMutableDictionary dictionary];
    return _stopNotifcationResults;
}
#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
#ifdef DEBUG
    NSLog(@"peripheral %@ didDiscoverServices %@", peripheral, error ? error.localizedFailureReason : self.peripheral.services);
#endif
    if(self.discoverServicesResult){
        self.discoverServicesResult(error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error
{
#ifdef DEBUG
    NSLog(@"peripheral %@ didDiscoverCharacteristicsForService:%@ %@", peripheral, service.UUID.UUIDString, error ? error.localizedFailureReason : service.characteristics);
#endif
    
    if(self.discoverCharacteristicsResult)
    {
        self.discoverCharacteristicsResult(error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    WriteCharacteristicResult result = [self getWriteCharacteristicResults:characteristic].firstObject;
    if(result){
        result(error);
        [[self getWriteCharacteristicResults:characteristic] removeObjectAtIndex:0];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    ReadCharacteristicResult result = [self getReadCharacteristicResults:characteristic].firstObject;
    if(result){
        result(characteristic.value, error);
        [[self getReadCharacteristicResults:characteristic] removeObjectAtIndex:0];
    }
    
    ListenNotificationResult notificationResult = [self getListenNotificationResults:characteristic].firstObject;
    if(notificationResult){
        notificationResult(characteristic.value, error);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(!characteristic.isNotifying && self.stopNotifcationResults[characteristic.UUID.UUIDString])
    {
        self.stopNotifcationResults[characteristic.UUID.UUIDString](error);
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"name"]){
        self.name = self.peripheral.name;
    }else if([keyPath isEqualToString:@"state"]){
        self.state = (BLEPeripheralState)self.peripheral.state;
    }
}

@end
