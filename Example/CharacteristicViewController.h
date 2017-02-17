//
//  CharacteristicViewController.h
//  BLEKit
//
//  Created by LevinYan on 2017/2/16.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface CharacteristicViewController : UITableViewController

@property (nonatomic, strong) CBCharacteristic *characteristic;
@end
