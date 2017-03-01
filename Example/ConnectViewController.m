//
//  ConnectViewController.m
//  BLEKit
//
//  Created by LevinYan on 2017/2/10.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import "ConnectViewController.h"
#import <FBKVOController.h>
#import "BLEManager.h"
#import "CharacteristicViewController.h"
@interface ConnectViewController ()

@property (nonatomic, strong) FBKVOController *kvoController;
@property (weak, nonatomic) IBOutlet UILabel *uuid;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

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

    BLEPeripheralConnectOption *option = [BLEPeripheralConnectOption defaultOption];
    option.autoReconnect = YES;
    option.needDiscoveredServices = _peripheral.bleManager.scanOption.serviceUUIDs;
    [_peripheral.bleManager connectPeripheral:_peripheral option:option complete:^(NSString * _Nullable error) {
        [wself.tableView reloadData];

    }];

    [self.kvoController observe:_peripheral keyPath:@"state" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        [wself updateUI];
    }];
    [self.kvoController observe:_peripheral keyPath:@"name" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        [wself updateUI];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDisconnect) name:kBLEPeripheralDisconnectedNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConnect) name:kBLEPeripheralConnectedNotificationKey object:nil];

}

- (void)handleDisconnect
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disconnect Alert" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [alertView show];
}
- (void)handleConnect
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connect Alert" message:nil delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [alertView show];

}
- (void)updateUI
{
    NSDictionary *state = @{@(BLEPeripheralStateConnected):@"Connected",
                            @(BLEPeripheralStateConnecting):@"Connecting",
                            @(BLEPeripheralStateDisconnected):@"Disconnected"};
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

- (void)dealloc
{
    [self.peripheral.bleManager cancelConnectPeripheral:self.peripheral];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.peripheral.services.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.peripheral.services[section].characteristics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    CBCharacteristic *characteristic = self.peripheral.services[indexPath.section].characteristics[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", characteristic.UUID];
    
    NSArray <NSString*> *properties = @[@"Broadcast",
                                        @"Read",
                                        @"WriteWithoutResponse",
                                        @"Write",
                                        @"Notify",
                                        @"Indicate",
                                        @"AuthenticatedSignedWrites",
                                        @"ExtendedProperties",
                                        @"NotifyEncryptionRequired",
                                        @"IndicateEncryptionRequired"];

    NSMutableString *detailString = [NSMutableString string];
    for(int i = 0; i <= properties.count; i++){
        
        if(characteristic.properties & (1 << i)){
            [detailString appendString:properties[i]];
            [detailString appendString:@" "];
        }
    }
    cell.detailTextLabel.text = detailString;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, header.frame.size.width - 30, 60)];
    label.numberOfLines = 0;
    CBService *service = self.peripheral.services[section];
    label.text = [NSString stringWithFormat:@"Service: %@", service.UUID];

    [header addSubview:label];
    return header;
}

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    return indexPath;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    CharacteristicViewController *vc = segue.destinationViewController;
    vc.peripheral = self.peripheral;
    vc.characteristic = self.peripheral.services[self.selectedIndexPath.section].characteristics[self.selectedIndexPath.row];
}


@end
