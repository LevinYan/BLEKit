//
//  ScanViewController.m
//  BLEKit
//
//  Created by LevinYan on 2017/1/22.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import "ScanViewController.h"
#import "BLEManager.h"

@interface ScanViewController ()

@property (nonatomic, strong) BLEManager *bleManager;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bleManager = [BLEManager shareManager];
    
    __weak typeof(self) wself = self;
    [self.bleManager initCentral:^{
        [wself scanPeripherals];
    }];
    
   

}

- (void)scanPeripherals
{
    __weak typeof(self) wself = self;
    [self.bleManager scanForPeripherals:nil result:^(CBPeripheral *peripheral) {
        [wself.tableView reloadData];
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
    name.text = p.peripheral.name ?: @"Unknow";
    rssi.text = [NSString stringWithFormat:@"%@", p.scanRSSI];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
