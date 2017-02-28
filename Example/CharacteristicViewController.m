//
//  CharacteristicViewController.m
//  BLEKit
//
//  Created by LevinYan on 2017/2/16.
//  Copyright © 2017年 LevinYan. All rights reserved.
//

#import "CharacteristicViewController.h"
#import "BLEManager.h"

@interface BLEData : NSObject

@property (nonatomic, strong) NSData *value;
@property (nonatomic, strong) NSString *stringValue;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString* stringDate;

@end

@implementation BLEData

+ (instancetype)data:(NSData*)data
{
    BLEData *bleData = [[BLEData alloc] init];
    bleData.value = data;
    bleData.date = [NSDate date];
    return bleData;
}

- (NSString*)stringValue
{
    
    NSMutableString *encodeValue = [NSMutableString string];
    [encodeValue appendString:@"0X"];
    UInt8 *bytes = (UInt8*)self.value.bytes;
    for(int i = 0; i < self.value.length; i++){
        [encodeValue appendString:[NSString stringWithFormat:@"%x%x",((bytes[i] >> 4) & 0x0F), (bytes[i] & 0x0F)]];
    }
    
    return encodeValue;
}

- (NSString*)stringDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:self.date];
    return currentDateString;
}
@end


static NSString *const ReadSection = @"Read New Value";
static NSString *const WriteSection = @"Write New Value";
static NSString *const NotifySection = @"Start Notification";

@interface CharacteristicViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *uuid;
@property (weak, nonatomic) IBOutlet UILabel *properties;
@property (nonatomic, strong) NSMutableArray<NSString*> *sections;
@property (nonatomic, strong) NSMutableArray<BLEData*> *readVaules;
@property (nonatomic, strong) NSMutableArray<BLEData*> *writeValues;
@property (nonatomic, strong) NSMutableArray<BLEData*> *notificationValues;


@end

@implementation CharacteristicViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.readVaules = [NSMutableArray array];
    self.writeValues = [NSMutableArray array];
    self.notificationValues = [NSMutableArray array];
    
    self.title = [NSString stringWithFormat:@"%@",_characteristic.UUID];
    self.uuid.text = self.characteristic.UUID.UUIDString;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.uuid.superview attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    NSDictionary<NSNumber*,NSString*> *propertiesDic = @{@(CBCharacteristicPropertyBroadcast):@"Broadcast",
                                 @(CBCharacteristicPropertyWriteWithoutResponse): @"Read",
                                 @(CBCharacteristicPropertyWriteWithoutResponse): @"WriteWithoutResponse",
                                 @(CBCharacteristicPropertyWrite): @"Write",
                                 @(CBCharacteristicPropertyNotify): @"Notify",
                                 @(CBCharacteristicPropertyIndicate): @"Indicate",
                                 @(CBCharacteristicPropertyAuthenticatedSignedWrites): @"AuthenticatedSignedWrites",
                                 @(CBCharacteristicPropertyExtendedProperties): @"ExtendedProperties",
                                 @(CBCharacteristicPropertyExtendedProperties): @"ExtendedProperties",
                                 @(CBCharacteristicPropertyNotifyEncryptionRequired): @"NotifyEncryptionRequired",
                                 @(CBCharacteristicPropertyIndicateEncryptionRequired): @"IndicateEncryptionRequired",};
    
    NSMutableString *properties = [NSMutableString string];
    for(NSNumber *key in propertiesDic.allKeys)
    {
        if(self.characteristic.properties & key.unsignedIntegerValue){
            
            if(properties.length)
                [properties appendString:@"\n"];
            [properties appendString:propertiesDic[key]];
        }
    }
    
    self.properties.text = properties;

    self.tableView.tableHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.tableHeaderView layoutIfNeeded];
    
    self.sections = [NSMutableArray array];
    if(self.characteristic.properties & CBCharacteristicPropertyRead){
        [self.sections addObject:ReadSection];
    }
    
    if(self.characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse ||
       self.characteristic.properties & CBCharacteristicPropertyWrite){
        [self.sections addObject:WriteSection];
        
    }
    if(self.characteristic.properties & CBCharacteristicPropertyNotify){
        [self.sections addObject:NotifySection];

    }
}



- (void)didReceiveMemoryWarnning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *_section = self.sections[section];
    if([_section isEqualToString:ReadSection]){
        return self.readVaules.count;
        
    }else if([_section isEqualToString:WriteSection]){
        return self.writeValues.count;
        
    }else if([_section isEqualToString:NotifySection]){
        return self.notificationValues.count;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.sectionHeaderHeight)];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 6, 140, 30)];
    button.backgroundColor = [UIColor colorWithRed:27/255.f green:128/255.f blue:216/255.f alpha:0.9];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 4;
    if([self.sections[section] isEqualToString:NotifySection]){
        if(self.characteristic.isNotifying)
            [button setTitle:@"Stop Notification" forState:UIControlStateNormal];
        else
            [button setTitle:@"Start Notification" forState:UIControlStateNormal];
    }else{
        [button setTitle:self.sections[section] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.tag = section;
    [button addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:button];
    
    return header;
}

- (void)headerClicked:(UIButton*)button
{
    NSString *section = self.sections[button.tag];
    if([section isEqualToString:ReadSection]){
        [self handleReadClicked:button];
        
    }else if([section isEqualToString:WriteSection]){
        [self handleWriteClicked:button];
        
    }else if([section isEqualToString:NotifySection]){
        [self handleNotifyClicked:button];
    }
}

- (void)handleReadClicked:(UIButton*)button
{
    __weak typeof(self) wself = self;
    [self.peripheral readValueForCharacteristic:self.characteristic result:^(NSData *value, NSError *error) {
        [wself.readVaules addObject:[BLEData data:value]];
        [wself.tableView reloadData];
    }];
}
- (void)handleWriteClicked:(UIButton*)button
{
    UIView *maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTap:)]];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.8;
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.clipsToBounds = YES;
    self.textField.layer.cornerRadius = 4;
    self.textField.layer.borderColor = [UIColor blackColor].CGColor;
    self.textField.layer.borderWidth = 0.5;
    CGPoint center = self.view.center;
    center.y -= 60;
    self.textField.center = center;
    [maskView addSubview:self.textField];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor colorWithRed:27/255.f green:128/255.f blue:216/255.f alpha:0.9];
    center = maskView.center;
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    cancelButton.clipsToBounds = YES;
    cancelButton.layer.cornerRadius = 4;
    center.x -= 60;
    center.y += 40;
    cancelButton.center = center;
    [cancelButton addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [maskView addSubview:cancelButton];
    
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    confirmButton.clipsToBounds = YES;
    confirmButton.layer.cornerRadius = 4;
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [confirmButton setTitle:@"confirm" forState:UIControlStateNormal];
    confirmButton.backgroundColor = [UIColor colorWithRed:27/255.f green:128/255.f blue:216/255.f alpha:0.9];
    [confirmButton addTarget:self action:@selector(confirmClicked:) forControlEvents:UIControlEventTouchUpInside];

    center = maskView.center;
    center.x += 60;
    center.y += 40;
    confirmButton.center = center;
    [maskView addSubview:confirmButton];
    
    [self.textField becomeFirstResponder];
    [self.navigationController.view addSubview:maskView];
}

- (void)cancelClicked:(UIButton*)button
{
    [button.superview removeFromSuperview];
    
}
- (void)confirmClicked:(UIButton*)button
{
    NSMutableData *data= [[NSMutableData alloc] init];
    
    NSMutableString *string = [NSMutableString string];
    if(self.textField.text.length % 2)
        [string appendString:@"0"];
    [string appendString:self.textField.text];
    
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length]/2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    [self.peripheral writeValue:data forCharacteristic:self.characteristic result:nil];
    [button.superview removeFromSuperview];
}
- (void)maskViewTap:(UITapGestureRecognizer*)gecognizer
{
    [gecognizer.view removeFromSuperview];
}
- (void)handleNotifyClicked:(UIButton*)button
{
    __weak typeof(self) wself = self;
    if(self.characteristic.isNotifying){
        
        [self.peripheral stopNotificationForCharacteristic:self.characteristic result:nil];
        [button setTitle:@"Stop Notification" forState:UIControlStateNormal];
    
    }else{
        
        [self.peripheral listenNotificationForCharacteristic:self.characteristic result:^(NSData *value, NSError *error) {
        [wself.notificationValues addObject:[BLEData data:value]];
        [wself.tableView reloadData];
        }];
        [button setTitle:@"Start Notification" forState:UIControlStateNormal];

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *section = self.sections[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    BLEData *data = nil;
    if([section isEqualToString:ReadSection]){
        data = self.readVaules[indexPath.row];
    }else if([section isEqualToString:WriteSection]){
        data = self.writeValues[indexPath.row];
    }else if([section isEqualToString:NotifySection]){
        data = self.notificationValues[indexPath.row];
    }
    cell.textLabel.text = data.stringValue;
    cell.detailTextLabel.text = data.stringDate;
    
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
