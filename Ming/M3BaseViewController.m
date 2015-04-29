//
// Created by xiaoweiwu on 4/28/14.
// Copyright (c) 2014 xiaowei wu. All rights reserved.
//

#import "M3BaseViewController.h"
#import "M3NewsViewController.h"
#import "M3UtilityViewController.h"
#import "M3DocumentViewController.h"
#import "M2ResourceDetailController.h" 
#import "CommonMacro.h"
@interface M3BaseViewController ()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *leftbarButtomItem;

@end

@implementation M3BaseViewController {

}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSBundle mainBundle]loadNibNamed:@"interfaceItems" owner:self options:nil];
    }
    return self;
}


-(void)updateAppreance{
    if ([self isMemberOfClass:[M2ResourceDetailController class]]) {
        self.navigationController.toolbarHidden=NO;
    }else{
        self.navigationController.toolbarHidden=YES;
    }

}

-(void)updateNavigationBar{
    
}

/**
 * 返回Action
 *
 *  @param sender Button
 */
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  定制navigationBarItem
 */

-(void)updateNavBarItem{
    UIBarButtonItem *leftBarButtomItem=[[UIBarButtonItem alloc]initWithCustomView:_leftbarButtomItem];
    
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
        self.navigationController.interactivePopGestureRecognizer.delegate=self;
    }

}

/**
 *  设置tabbar
 *
 *  @param image    图片
 *  @param selImage 选中图片
 */
-(void)setTabBarItemWithImage:(UIImage *)image withSelectedImage:(UIImage *)selImage{
    UITabBarItem *tabBarItem=self.tabBarItem;
    UIImage *iconImage=image;
    UIImage *scaledImage =
    [UIImage imageWithCGImage:[iconImage CGImage]
                        scale:(iconImage.scale * 2.0)
                  orientation:(iconImage.imageOrientation)];
    selImage=[UIImage imageWithCGImage:[selImage CGImage]
                                 scale:selImage.scale*2.0
                           orientation:selImage.imageOrientation];
    
    
    [tabBarItem setFinishedSelectedImage:selImage withFinishedUnselectedImage:scaledImage];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

/**
 *  设置tabbar
 *
 *  @param image 图片
 */


-(void)setTabBarItemWithImage:(UIImage *)image{
    UITabBarItem *tabBarItem=self.tabBarItem;
    UIImage *iconImage=image;
    UIImage *scaledImage =
    [UIImage imageWithCGImage:[iconImage CGImage]
                        scale:(iconImage.scale * 2.0)
                  orientation:(iconImage.imageOrientation)];
    [tabBarItem setImage:scaledImage];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateNavBarItem];
    self.view.backgroundColor = HexColor(0Xebeff2);

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateNavigationBar];
    [self updateAppreance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end