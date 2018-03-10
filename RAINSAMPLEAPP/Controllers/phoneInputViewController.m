//
//  phoneInputViewController.m
//  RAINSAMPLEAPP
//
//  Created by Daniel Katz on 3/8/18.
//  Copyright © 2018 korrent. All rights reserved.
//

#import "phoneInputViewController.h"
#import "verifyPinViewController.h"
@interface phoneInputViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberTF;

@end

@implementation phoneInputViewController
- (IBAction)enterNumber:(id)sender {
    NSString * number = _numberTF.text;
    NSString *normalizedPhone = [RSOSUtilsString normalizePhoneNumber:number prefix:@""]; // '12345678888'
    
    RSOSAuthManager *userManager = [RSOSAuthManager sharedInstance];
    
    [userManager requestPinWithPhoneNumber:normalizedPhone callback:^(RSOSResponseStatusDataModel *status) {
        
        if([status isSuccess]) {
            [self performSegueWithIdentifier:@"goVerify" sender:self];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"goVerify"]) {
        verifyPinViewController * dest = (verifyPinViewController *)segue.destinationViewController;
        dest.phoneNumber = self.numberTF.text;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
