//
//  profileViewController.h
//  RAINSAMPLEAPP
//
//  Created by Daniel Katz on 3/8/18.
//  Copyright © 2018 korrent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RSOSData/RSOSData.h>
@interface profileViewController : UIViewController
/**
 * @abstract User profile data model
 */

@property (strong, nonatomic) RSOSDataUserProfile *modelProfile;

/**
 *
 */

@property (strong, nonatomic) NSMutableArray<RSOSDataSavedLocation *> *savedLocations;

/**
 * @abstract User profile phone number
 */

@property (strong, nonatomic) NSString *phoneNumber;

/**
 * @abstract Flag indicating the user phone has been verified
 */

@property (assign, atomic) BOOL isPhoneVerified;

/**
 * @abstract Flag indicating that a call flow request is active
 */

@property (atomic,readonly,assign) BOOL startingCallFlow;
@end
