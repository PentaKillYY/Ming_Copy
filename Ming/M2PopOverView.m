//
//  M2PopOverView.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/23/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//
#import "M2PopOverView.h"

@implementation M2PopOverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    self.innerView.layer.cornerRadius=5;
}

-(void)dismiss{
    [self removeFromSuperview];
}

-(void)setPopOverWithInfo:(NSDictionary *)info{
    self.nameLabel.text=info[@"name"];
    self.uploadTimeLabel.text=info[@"upload_time"];
    
    CGFloat byteSize=[info[@"size"] floatValue];
    CGFloat kBSize=byteSize/1024;
    CGFloat mBSize=kBSize/1024;
    
    if(mBSize>1.0){
        self.sizeLabel.text=[NSString stringWithFormat:@"%.1fM",mBSize];
    }else{
        self.sizeLabel.text=[NSString stringWithFormat:@"%.1fK",kBSize];
    }
}

-(void)showInView:(UIView *)view{
    self.frame=view.bounds;
    [view addSubview:self];
    
    self.innerView.layer.anchorPoint=CGPointMake(0.9, 0);
    self.innerView.frame=CGRectMake(6, 70, 308, 97);
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    scale.duration=0.5;
    scale.fromValue=[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)];
    scale.toValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    [self.innerView.layer addAnimation:scale forKey:@"scale"];
}

@end
