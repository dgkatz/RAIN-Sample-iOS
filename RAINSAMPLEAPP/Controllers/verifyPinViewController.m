//
//  verifyPinViewController.m
//  RAINSAMPLEAPP
//
//  Created by Daniel Katz on 3/8/18.
//  Copyright © 2018 korrent. All rights reserved.
//

#import "verifyPinViewController.h"

@interface verifyPinViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pinTF;

@end

@implementation verifyPinViewController
- (IBAction)verify:(id)sender {
    NSString *verificationCode = self.pinTF.text; // e.g. @"12345"
    
    RSOSAuthManager *userManager = [RSOSAuthManager sharedInstance];
    NSLog(@"%@", _phoneNumber);
    [userManager requestValidatePin:verificationCode forPhoneNumber:_phoneNumber callback:^(RSOSResponseStatusDataModel *status) {
        
        if([status isSuccess]) {
            [self performSegueWithIdentifier:@"toProfile" sender:self];
            // handle success
        }
        else {
            // handle error
        }
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
