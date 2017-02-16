//
//  ConnectViewController.m
//  BLEKit
//
//  Created by LevinYan on 2017/2/10.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import "ConnectViewController.h"
#import <FBKVOController.h>

@interface ConnectViewController ()

@property (nonatomic, strong) FBKVOController *kvoController;
@property (weak, nonatomic) IBOutlet UILabel *uuid;
@property (weak, nonatomic) IBOutlet UILabel *state;

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.kvoController = [[FBKVOController alloc] initWithObserver:self retainObserved:NO];
}

- (void)setPeripheral:(BLEPeripheral *)peripheral
{
    _peripheral = peripheral;
    
    __weak typeof(self) wself = self;
    [self.kvoController observe:_peripheral keyPath:@"state" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        [wself updateUI];
    }];
    [self.kvoController observe:_peripheral keyPath:@"name" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        [wself updateUI];
    }];
    
}

- (void)updateUI
{
    NSDictionary *state = @{@(BLEPeripheralStateConnected):@"Connected",
                            @(BLEPeripheralStateConnecting):@"Connecting",
                            @(BLEPeripheralStateDisconnected):@"isconnected"};
    NSDictionary *colors = @{@(BLEPeripheralStateConnected):[UIColor greenColor],
                             @(BLEPeripheralStateConnecting):[UIColor blueColor],
                             @(BLEPeripheralStateDisconnected):[UIColor redColor]};
    
    self.title = self.peripheral.name;
    self.uuid.text = self.peripheral.identifier.UUIDString;
    self.state.text = state[@(self.peripheral.state)];
    self.state.textColor = colors[@(self.peripheral.state)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
