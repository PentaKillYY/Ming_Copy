//
//  M2LoadHUD.m
//  Ming
//
//  Created by wu xiaowei on 14/12/11.
//  Copyright (c) 2014年 xiaowei wu. All rights reserved.
//

#import "M2LoadHUD.h"
#import "AppDelegate.h"

@implementation M2LoadHUD{
    UIImageView *_imageView;
    NSMutableArray *_images;
    UIView *_backView;
    UILabel *_loadLabel;
}

+(instancetype)sharedHUD{
    static M2LoadHUD *sharedHUD;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHUD=[[M2LoadHUD alloc]init];
    });
    return sharedHUD;
}


-(instancetype)init{
    if (self=[super init]) {
        _imageView=[[UIImageView alloc]init];
        _images=[NSMutableArray array];
        for (int i=1; i<9; i++) {
            NSString *imageName=[NSString stringWithFormat:@"l%d",i];
            UIImage *image=[UIImage imageNamed:imageName];
            [_images addObject:image];
        }
        _imageView.animationImages=_images;
        _imageView.animationDuration=1;
        _imageView.animationRepeatCount=0;
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        
        _backView=[[UIView alloc]init];
        _backView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
        _backView.layer.masksToBounds=YES;
        _backView.layer.cornerRadius=8;
        
        [_backView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        _loadLabel=[[UILabel alloc] init];
        _loadLabel.backgroundColor=[UIColor clearColor];
        _loadLabel.text=NSLocalizedString(@"wait", @"");
        _loadLabel.textColor=[UIColor whiteColor];
        _loadLabel.font=[UIFont systemFontOfSize:11];
        [_loadLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

-(void)show{
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    UIWindow *window=[appDelegate window];
    [window addSubview:_backView];
    [window addSubview:_imageView];
    [window addSubview:_loadLabel];
    NSLayoutConstraint *centerX=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterY multiplier:1 constant:-10];
    NSLayoutConstraint *backCenterX=[NSLayoutConstraint constraintWithItem:_backView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *backCenterY=[NSLayoutConstraint constraintWithItem:_backView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *backWidth=[NSLayoutConstraint constraintWithItem:_backView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeWidth multiplier:2 constant:0];
    NSLayoutConstraint *backHeight=[NSLayoutConstraint constraintWithItem:_backView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeHeight multiplier:2 constant:0];
    NSLayoutConstraint *labelCenterX=[NSLayoutConstraint constraintWithItem:_loadLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *labelTop=[NSLayoutConstraint constraintWithItem:_loadLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:8];
    

    [window addConstraints:@[centerX,centerY,backCenterX,backCenterY,backWidth,backHeight,labelCenterX,labelTop]];
    [_imageView startAnimating];
    self.isShow = YES;
    
}

-(void)dismiss{
    [_imageView stopAnimating];
    [_imageView removeFromSuperview];
    [_backView removeFromSuperview];
    [_loadLabel removeFromSuperview];
    self.isShow = NO;
}
@end
