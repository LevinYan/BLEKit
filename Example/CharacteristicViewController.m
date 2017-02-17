//
//  CharacteristicViewController.m
//  BLEKit
//
//  Created by LevinYan on 2017/2/16.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import "CharacteristicViewController.h"

@interface CharacteristicViewController ()

@property (weak, nonatomic) IBOutlet UILabel *uuid;
@property (weak, nonatomic) IBOutlet UILabel *properties;

@end

@implementation CharacteristicViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@",_characteristic.UUID];
    self.uuid.text = _characteristic.UUID.UUIDString;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.uuid.superview attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    NSMutableString *properties = [NSMutableString string];
    
    if(_characteristic.properties &
       CBCharacteristicPropertyBroadcast){
        [properties appendString:@"Broadcast\n"];
        
    }
    if(_characteristic.properties &
             CBCharacteristicPropertyRead){
        [properties appendString:@"Read\n"];
        
    }
    if(_characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse){
        [properties appendString:@"WriteWithoutResponse\n"];
        
    }
    if(_characteristic.properties &
             CBCharacteristicPropertyWrite){
        [properties appendString:@"Write\n"];
        
    }
    if(_characteristic.properties &
             CBCharacteristicPropertyNotify){
        [properties appendString:@"Notify\n"];
        
    }
    if(_characteristic.properties &
             CBCharacteristicPropertyIndicate){
        [properties appendString:@"Indicate\n"];
        
    }
    if(_characteristic.properties & CBCharacteristicPropertyAuthenticatedSignedWrites){
        [properties appendString:@"AuthenticatedSignedWrites\n"];
        
    }
    if(_characteristic.properties & CBCharacteristicPropertyExtendedProperties){
        [properties appendString:@"ExtendedProperties\n"];
        
    }
    if(_characteristic.properties & CBCharacteristicPropertyNotifyEncryptionRequired){
        [properties appendString:@"NotifyEncryptionRequired\n"];
        
    }
    if(_characteristic.properties & CBCharacteristicPropertyIndicateEncryptionRequired){
        [properties appendString:@"IndicateEncryptionRequired\n"];
        
    }
    [properties deleteCharactersInRange:NSMakeRange(properties.length - 1, 1)];
    self.properties.text = properties;

    self.tableView.tableHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.tableHeaderView layoutIfNeeded];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarnning {
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
