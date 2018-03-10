//
//  loginViewController.m
//  RAINSAMPLEAPP
//
//  Created by Daniel Katz on 3/8/18.
//  Copyright © 2018 korrent. All rights reserved.
//

#import "loginViewController.h"
static NSString* const CLIENT_ID = @"AGh1XunAE4D4o7AlKjCWTUNAXtJlCZ3m";
static NSString* const CLIENT_SECRET = @"wL9ALkJcbOU85BOy";

@interface loginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation loginViewController

- (IBAction)login:(id)sender {
    NSString *username = _usernameTF.text;
    NSString *email = _emailTF.text;
    NSString *password = _passwordTF.text;
    
    RSOSAuthManager *userManager = [RSOSAuthManager sharedInstance];
    
    [userManager requestLoginWithUsername:username password:password callback:^(RSOSResponseStatusDataModel *status) {
        
        if([status isSuccess]) {
            [self performSegueWithIdentifier:@"login" sender:self];
            // handle success
        }
        else {
            // handle error
        }
        
    }];
}

- (IBAction)signup:(id)sender {
    NSString *username = _usernameTF.text;
    NSString *email = _emailTF.text;
    NSString *password = _passwordTF.text;
    NSLog(@"u: %@, e: %@, p:%@", username,email,password);
    
    RSOSAuthManager *userManager = [RSOSAuthManager sharedInstance];
    
    [userManager requestRegisterWithUsername:username password:password email:email callback:^(RSOSResponseStatusDataModel *status) {
        
        if([status isSuccess]) {
            [userManager requestLoginWithUsername:username password:password callback:^(RSOSResponseStatusDataModel *status) {
                
                if([status isSuccess]) {
                    [self performSegueWithIdentifier:@"signupSucces" sender:self];
                    // handle success
                }
                else {
                    // handle error
                }
                
            }];
            // handle success
        }
        else {
            NSLog(@"Unsucceful signup, %@", status.description);
            // handle error
        }
        
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    [[RSOSAuthManager sharedInstance] initializeManager];
    [RSOSAuthManager sharedInstance].clientID = @"AGh1XunAE4D4o7AlKjCWTUNAXtJlCZ3m";
    [RSOSAuthManager sharedInstance].clientSecret = @"wL9ALkJcbOU85BOy";
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
