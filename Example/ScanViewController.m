//
//  ScanViewController.m
//  BLEKit
//
//  Created by LevinYan on 2017/1/22.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import "ScanViewController.h"
#import "BLEManager.h"
#import "ConnectViewController.h"

@interface ScanViewController ()

@property (nonatomic, strong) BLEManager *bleManager;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bleManager = [BLEManager shareManager];
    
    [self.bleManager initCentral:nil];
    __weak typeof(self) wself = self;
   
    BLEPeripheralScanOption *scanOption = [BLEPeripheralScanOption new];
    scanOption.allowDuplicate = YES;
    scanOption.timeout = 10;
    [self.bleManager scanForPeripherals:scanOption result:^(CBPeripheral *peripheral, BOOL finished) {
        [wself.tableView reloadData];
        if(finished)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Scan Finished" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [BLEManager shareManager].discoveredPeripherals.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UILabel *name = cell.contentView.subviews.firstObject;
    UILabel *rssi = cell.contentView.subviews.lastObject;
    
    BLEPeripheral *p = [BLEManager shareManager].discoveredPeripherals[indexPath.row];
    name.text = p.name ?: @"Unknow";
    rssi.text = [NSString stringWithFormat:@"%@", p.RSSI];
    
    return cell;
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    ConnectViewController *vc = segue.destinationViewController;
    [vc view];
    vc.peripheral = self.bleManager.discoveredPeripherals[self.selectedIndex];
}


@end
