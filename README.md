# BLEKit
BLEKit is a very simple libray for BLE develope in iOS   

##BLEKit has the following advantage

* Very Simple API With Block
* Support Custom Timeout For Scan and Connection
* Support Auto Discovery Service
* Support Auto Reconnect



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
    BLEPeripheralConnectOption *option = [BLEPeripheralConnectOption defaultOption];
    option.autoReconnect = YES; //enable auto reconnect when disconnect
    option.autoDiscoverServices = YES; //enable auto discovery service when connect
    [self.bleManager connectPeripheral:peripheral option:nil complete:^(NSString * _Nullable error) {
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
#Run Example
![](https://github.com/LevinYan/BLEKit/blob/master/raw/2.png)
![](https://github.com/LevinYan/BLEKit/blob/master/raw/3.png)

#Contact Me
If you have any issue need to contact me, just contact me by QQ:243765379 or email:243765379@qq.com 

