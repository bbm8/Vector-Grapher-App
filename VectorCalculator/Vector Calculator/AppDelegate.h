//
//  AppDelegate.h
//  Vector Calculator
//
//  Created by Vikram Mullick on 5/20/16.
//  Copyright © 2016 Vikram Mullick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *calculationDataString;

}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) NSString *calculationDataString;

@end

