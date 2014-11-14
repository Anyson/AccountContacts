//
//  ViewController.m
//  AccountContacts
//
//  Created by Anyson Chan on 14/11/14.
//  Copyright (c) 2014年 Sachsen. All rights reserved.
//

#import "ViewController.h"
#import "ContactHandler.h"

@interface ViewController ()

@property (strong, nonatomic) ContactHandler *contacthandler;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _contacthandler = [[ContactHandler alloc] init];
    [_contacthandler gainAllContactPerson];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
