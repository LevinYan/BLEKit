# BLEKit
BLEKit is a very simple libray for BLE develope in iOS   


#Installation
```
pod 'LYBLEKit', '~> 1.0.0'

```

#How to Use this library
##Init 
```objc
  self.bleManager = [BLEManager shareManager];
  [self.bleManager initCentral:nil];
```
##Scan Peripheral
```objc
[self.bleManager scanForPeripherals:nil result:^(CBPeripheral *peripheral) {
       do something...
    }];
```
##Connect Peripheral
```objc
 [self.bleManager connectPeripheral:_peripheral option:nil complete:^(NSString * _Nullable error) {
       do something...
    }];
```
##Read Data
```objc
 [self.peripheral readValueForCharacteristic:self.characteristic result:^(NSData *value, NSError *error) {
        do something...
    }];
```
##Write Data
```objc
      [self.peripheral writeValue:data forCharacteristic:self.characteristic result:^(NSError * _Nullable error) {
        do something...
    }];
```
##Start Notification
```objc
    [self.peripheral listenNotificationForCharacteristic:self.characteristic result:^(NSData *value, NSError *error) {
           do something...
    }];
```
