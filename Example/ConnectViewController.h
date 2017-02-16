//
//  ConnectViewController.h
//  BLEKit
//
//  Created by LevinYan on 2017/2/10.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEPeripheral.h"
@interface ConnectViewController : UITableViewController

@property (nonatomic, strong) BLEPeripheral *peripheral;
@end
