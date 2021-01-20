//
//  ViewController.m
//  StarIODeviceSettingLabs
//
//  Created by 2019-131 on 2020/12/23.
//  Copyright © 2020 Star Micronics. All rights reserved.
//

#import "ViewController.h"
#import <StarIODeviceSetting/StarIODeviceSetting.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *portNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *steadyLanSettingButton;
- (IBAction)apply:(id)sender;
- (IBAction)load:(id)sender;
- (IBAction)showSteadyLanSettingOptions:(id)sender;
@property (nonatomic) SMSteadyLANSetting steadyLANSetting;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)apply:(id)sender {
    NSLog(@"Apply SteadyLAN Setting");
    NSError  *error = nil;
    NSString *portName = self.portNameTextField.text;
    
    // Please refer to the SDK manual for portName argument which using for communicating with the printer.
    // (https://www.star-m.jp/products/s_print/sdk/starprnt_sdk/manual/ios_objc/en/api_stario_port.html#getport)
    SMNetworkManager *smNetworkManager = [[SMNetworkManager alloc] initWithPortName:portName];
    
    SMNetworkSetting *smNetworkSetting = [[SMNetworkSetting alloc] init];
    smNetworkSetting.steadyLAN = self.steadyLANSetting;
    
    [smNetworkManager applyNetworkSetting:smNetworkSetting error:&error];
    
    if (error != nil) {
        [self showSimpleAlertWithTitle:@"Communication Result"
                               message:error.localizedDescription
                           buttonTitle:@"Close"
                           buttonStyle:UIAlertActionStyleCancel
                            completion:nil];
        return;
    }
    
    [self showSimpleAlertWithTitle:@"Communication Result"
                           message:@"Data transmission succeeded.Please confirm the current settings by load method after a printer reset is executed."
                       buttonTitle:@"Close"
                       buttonStyle:UIAlertActionStyleCancel
                        completion:nil];

}

- (IBAction)load:(id)sender {
    NSLog(@"Load SteadyLAN Setting");
    
    NSError *error = nil;
    NSString *portName = self.portNameTextField.text;
    
    // Please refer to the SDK manual for portName argument which using for communicating with the printer.
    // (https://www.star-m.jp/products/s_print/sdk/starprnt_sdk/manual/ios_objc/en/api_stario_port.html#getport)
    SMNetworkManager *smNetworkManager = [[SMNetworkManager alloc] initWithPortName:portName];
    
    SMNetworkSetting *smNetworkSetting = [smNetworkManager loadWithError:&error];
    
    if (error != nil) {
        [self showSimpleAlertWithTitle:@"Communication Result"
                               message:error.localizedDescription
                           buttonTitle:@"Close"
                           buttonStyle:UIAlertActionStyleCancel
                            completion:nil];
        return;
    }
    
    NSString *networkSettingString = @"";
    switch (smNetworkSetting.steadyLAN) {
        case SMSteadyLANSettingDisable:
            networkSettingString = @"disable";
            break;
        case SMSteadyLANSettingIOS:
            networkSettingString = @"iOS";
            break;
        case SMSteadyLANSettingAndroid:
            networkSettingString = @"android";
            break;
        case SMSteadyLANSettingWindows:
            networkSettingString = @"windows";
            break;
        default:
        case SMSteadyLANSettingUnspecified:
            networkSettingString = @"unspecified";
            break;
    }
    
    
    [self showSimpleAlertWithTitle:@"Communication Result"
                           message:[NSString stringWithFormat:@"SteadyLAN Setting: %@",networkSettingString]
                       buttonTitle:@"Close"
                       buttonStyle:UIAlertActionStyleCancel
                        completion:nil];
}

- (IBAction)showSteadyLanSettingOptions:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SteadyLANSetting"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Unspecified"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                self->_steadyLANSetting = SMSteadyLANSettingUnspecified;
                                                [self.steadyLanSettingButton setTitle:@"Unspecified" forState:UIControlStateNormal];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Disable"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                self->_steadyLANSetting = SMSteadyLANSettingDisable;
                                                [self.steadyLanSettingButton setTitle:@"Disable" forState:UIControlStateNormal];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Enable(for iOS)"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                self->_steadyLANSetting = SMSteadyLANSettingIOS;
                                                [self.steadyLanSettingButton setTitle:@"Enable(for iOS)" forState:UIControlStateNormal];
                                                
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Enable(for Android)"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                self->_steadyLANSetting = SMSteadyLANSettingAndroid;
                                                [self.steadyLanSettingButton setTitle:@"Enable(for Android)" forState:UIControlStateNormal];
                                                
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Enable(for Windows)"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                self->_steadyLANSetting = SMSteadyLANSettingWindows;
                                                [self.steadyLanSettingButton setTitle:@"Enable(for Windows)" forState:UIControlStateNormal];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self.navigationController popViewControllerAnimated:YES];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showSimpleAlertWithTitle:(NSString *)title
                         message:(NSString *)message
                     buttonTitle:(NSString *)buttonTitle
                     buttonStyle:(UIAlertActionStyle)buttonStyle
                      completion:(void (^)(UIAlertController *alertController))completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle
                                                     style:buttonStyle
                                                   handler:nil];
    
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
            completion(alertController);
        }
    });
}

@end
