//
//  M3BackViewController.m
//  Ming
//
//  Created by xiaoweiwu on 4/30/14.
//  Copyright (c) 2014 xiaowei wu. All rights reserved.
//

#import "M3BackViewController.h"

@interface M3BackViewController ()

@end

@implementation M3BackViewController



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;

    }
    return self;
}

/**
 *  定制NavBar
 */

-(void)updateNavBarItem{
    UIBarButtonItem *leftBarButtomItem=[[UIBarButtonItem alloc]initWithCustomView:self.backBarButtonItem];
    
    //    _backBarItemView.superview.frame=CGRectOffset(_backBarItemView.superview.frame, 20,0);
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    if (IS_VERSION7) {
        negativeSpacer.width=-16;
    }else{
        negativeSpacer.width=-6;
    }
    
    
    self.navigationItem.leftBarButtonItems=@[negativeSpacer,leftBarButtomItem];
    
    
    if (IS_VERSION7) {
//        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }

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
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
