//
//  profileViewController.m
//  RAINSAMPLEAPP
//
//  Created by Daniel Katz on 3/8/18.
//  Copyright © 2018 korrent. All rights reserved.
//

#import "profileViewController.h"
#import "RSOSLocationManager.h"
#import "RSOSCallFlowAPIManager.h"
@interface profileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *allergiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodTypeLabel;

@end

@implementation profileViewController

- (IBAction)panic:(id)sender {

    /** Sample Callflow payload
     * The sample callflow requires the following parameters:
     *
     * - location
     * the user's current location
     *
     * - user
     * the user making the emergency call
     *
     * - contacts
     * an array of emergency contacts, each of which will be called in sequence
     * if the user does not answer the emergency call they trigger
     *
     * JSON Example:
     *
     * {
     *   "variables" : {
     *     "location" : {
     *       "latitude": "40.7128",
     *       "longitude": " -74.0059",
     *       "uncertainty": "65.0"
     *     },
     *     "user": {
     *       "full_name": "Alice Smith",
     *       "phone_number": "+12345551234"
     *     },
     *     "contacts": [
     *       {
     *         "full_name": "Bob Smith",
     *         "phone_number": "+12345554321"
     *       }
     *     ]
     *   }
     * }
     *
     */
    
    /**
     * Don't trigger call flow if an active flow already exists
     *
     */
    
    if(self.startingCallFlow) {
        
        RSOSResponseStatusDataModel *responseStatus = [[RSOSResponseStatusDataModel alloc] init];
        responseStatus.status = RSOSHTTPResponseCodeThrottle;
        responseStatus.message = @"There is already an active call flow.";

        return;
    }
    
    _startingCallFlow = YES;
    
    RSOSLocationManager *managerLocation = [RSOSLocationManager sharedInstance];
    
    NSDictionary *dictLocation = @{@"latitude": [NSString stringWithFormat:@"%.6f", managerLocation.location.coordinate.latitude],
                                   @"longitude": [NSString stringWithFormat:@"%.6f", managerLocation.location.coordinate.longitude],
                                   @"uncertainty": [NSString stringWithFormat:@"%.6f", managerLocation.location.horizontalAccuracy],
                                   };
    
    NSString *callerFullName = _fullNameLabel.text;
    
    /**
     * If the user has not set their profile phone number, fall back on their verified phone number
     */
    
    NSString *callerPhone = [self.modelProfile.phoneNumbers getPrimaryValue].phoneNumber;
    
    callerPhone = [RSOSUtilsString normalizePhoneNumber:@"16176008784" prefix:@"+"];
    
    NSDictionary *dictUser = @{@"full_name": callerFullName,
                               @"phone_number": callerPhone
                               };
    
    NSMutableArray *arrayContacts = [[NSMutableArray alloc] init];
    
    if ([self.modelProfile.emergencyContacts isSet] == YES) {
        
        for (RSOSDataEmergencyContact *contact in self.modelProfile.emergencyContacts.values) {
            
            [arrayContacts addObject:@{@"full_name": contact.fullName,
                                       @"phone_number": [RSOSUtilsString normalizePhoneNumber:contact.phoneNumber prefix:@"+"]
                                       }];
        }
    }
    
    NSDictionary *variables = @{@"location": dictLocation,
                                @"user": dictUser,
                                @"contacts": arrayContacts,
                                @"company": @"Dan's Company"
                                };
    
    NSString *callFlow = @"kronos_contacts";
    
    [RSOSCallFlowAPIManager requestTriggerCallWithCallFlow:callFlow variables:variables callback:^(RSOSResponseStatusDataModel *status) {
        _startingCallFlow = NO;
        
        if(![status isSuccess]) {
            NSLog(@"Callflow Failed");
        }else{
            NSLog(@"Callflow Success");
        }

    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    RSOSDataClient *dataClient = [RSOSDataClient defaultClient];
    
    [dataClient getProfileWithCallback:^(RSOSResponseStatusDataModel * _Nonnull status, RSOSDataUserProfile * _Nonnull profile) {
        
        if([status isSuccess]) {
            self.modelProfile = [[RSOSDataUserProfile alloc] init];
            self.modelProfile = profile;
            _fullNameLabel.text = profile.fullName.getPrimaryValue;
            
            RSOSDataAddress *address = [profile.addresses getPrimaryValue];
            _adressLabel.text = [[NSString alloc]initWithFormat:@"%@, %@ , %@, %@, %@, %@",address.label, address.streetAddress,address.locality, address.postalCode,address.region, address.countryCode];
            
            _allergiesLabel.text = profile.allergies.getPrimaryValue;
            _bloodTypeLabel.text = profile.bloodType.getPrimaryValue;
        }
        
    }];
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
