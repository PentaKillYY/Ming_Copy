//
//  M3DocumentViewController.m
//  Ming
//
//  Created by xiaoweiwu on 4/29/14.
//  Copyright (c) 2014 xiaowei wu. All rights reserved.
//

#import "M3DocumentViewController.h"

@interface M3DocumentViewController ()

@end

@implementation M3DocumentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=NSLocalizedString(@"文档", @"");
        [self setTabBarItemWithImage:[UIImage imageNamed:@"doc_icon"] withSelectedImage:[UIImage imageNamed:@"doc_icon"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
