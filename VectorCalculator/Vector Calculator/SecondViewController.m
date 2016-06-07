//
//  SecondViewController.m
//  Vector Calculator
//
//  Created by Vikram Mullick on 5/20/16.
//  Copyright © 2016 Vikram Mullick. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property AppDelegate *appDelegate;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    UIFont *myFont = [UIFont fontWithName:@"Helvetica Neue" size:25];

    UIColor *color = [UIColor whiteColor];
    
    [self.infoLabel setTextColor:color];
    self.infoLabel.numberOfLines = 13;
    self.infoLabel.text = self.appDelegate.calculationDataString;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.font = myFont;
 


}
-(void)viewDidAppear:(BOOL)animated
{
    self.infoLabel.text = self.appDelegate.calculationDataString;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
