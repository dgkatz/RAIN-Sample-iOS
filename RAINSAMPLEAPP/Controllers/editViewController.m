//
//  editViewController.m
//  RAINSAMPLEAPP
//
//  Created by Daniel Katz on 3/9/18.
//  Copyright © 2018 korrent. All rights reserved.
//

#import "editViewController.h"

@interface editViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fullNameTF;
@property (weak, nonatomic) IBOutlet UITextField *labelTF;
@property (weak, nonatomic) IBOutlet UITextField *adressTF;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UITextField *stateTF;
@property (weak, nonatomic) IBOutlet UITextField *zipTF;
@property (weak, nonatomic) IBOutlet UITextField *countryCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *allergiesTF;
@property (weak, nonatomic) IBOutlet UITextField *bloodTypeTF;

@end

@implementation editViewController

- (IBAction)save:(id)sender {
    RSOSDataClient *dataClient = [RSOSDataClient defaultClient];
    
    [dataClient getProfileWithCallback:^(RSOSResponseStatusDataModel * _Nonnull status, RSOSDataUserProfile * _Nonnull profile) {
        
        if([status isSuccess]) {
            [profile.fullName setPrimaryValue:_fullNameTF.text];
            RSOSDataAddress *homeAddress = [profile.addresses getPrimaryValue];
            if(homeAddress == nil) {
                
                // Create an address value if none exists:
                
                homeAddress = [[RSOSDataAddress alloc] init];
            }

            homeAddress.label = _labelTF.text;
            homeAddress.streetAddress = _adressTF.text;
            homeAddress.locality = _cityTF.text;
            homeAddress.region = _stateTF.text;
            homeAddress.postalCode = _zipTF.text;
            homeAddress.countryCode = _countryCodeTF.text;
            [profile.addresses setPrimaryValue:homeAddress];
            [profile.allergies setPrimaryValue:_allergiesTF.text];
            [profile.bloodType setPrimaryValue:_bloodTypeTF.text];

            RSOSDataClient *dataClient = [RSOSDataClient defaultClient];
            
            [dataClient patchProfile:profile callback:^(RSOSResponseStatusDataModel * _Nonnull status, RSOSDataUserProfile * _Nonnull profile) {
                
                if([status isSuccess]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }];
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    RSOSDataClient *dataClient = [RSOSDataClient defaultClient];
    
    [dataClient getProfileWithCallback:^(RSOSResponseStatusDataModel * _Nonnull status, RSOSDataUserProfile * _Nonnull profile) {
        
        if([status isSuccess]) {
            _fullNameTF.text = profile.fullName.getPrimaryValue;
            RSOSDataAddress *homeAddress = [profile.addresses getPrimaryValue];
            _labelTF.text = homeAddress.label;
            _adressTF.text = homeAddress.streetAddress;
            _cityTF.text = homeAddress.locality;
            _stateTF.text = homeAddress.region;
            _zipTF.text = homeAddress.postalCode;
            _countryCodeTF.text = homeAddress.countryCode;
            
            _allergiesTF.text = profile.allergies.getPrimaryValue;
            _bloodTypeTF.text = profile.bloodType.getPrimaryValue;
        }
        
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    // Do any additional setup after loading the view.
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
