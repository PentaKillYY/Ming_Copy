//
//  M2MailSearchCell.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-13.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2MailSearchCell.h"

@interface M2MailSearchCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
@property (weak, nonatomic) IBOutlet UILabel *bgTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *mailButton;
@property (weak, nonatomic) IBOutlet UILabel *mailUnderLineLabel;

@property (weak, nonatomic) IBOutlet UILabel *departmentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationTitleLabel;
@end


@implementation M2MailSearchCell{
    NSDictionary *_infoDict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithDict:(NSDictionary *)dict{
    _infoDict=dict;
    _nameLabel.text=dict[@"employee_name"];
    _accountLabel.text=dict[@"employee_no"];
    _locationLabel.text = dict[@"work_location"];
    _departmentLabel.text = dict[@"department_name"];
    
    //_locationLabel.text=dict[@"work_location"];
    //[_mailButton setTitle:dict[@"e_mail"] forState:UIControlStateNormal];
    
//    //添加下划线
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:dict[@"e_mail"]];
//    NSRange strRange = {0,[str length]};
//    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleThick] range:strRange];
//    [_mailButton setAttributedTitle:str forState:UIControlStateNormal];
    
    //自动根据内容设置label的宽度
    //设置部门的宽度
    NSArray *bgArray=[dict[@"department_name"] componentsSeparatedByString:@"_"];
    if(bgArray.count>0){
        _bgLabel.numberOfLines = 0;
    
        _bgLabel.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont *font = [UIFont systemFontOfSize:12];
        _bgLabel.font = [UIFont systemFontOfSize:12];
    
        CGSize size = CGSizeMake(187,2000);
        CGSize labelsize = [bgArray[0] sizeWithFont:font constrainedToSize:size lineBreakMode:_departmentLabel.lineBreakMode];
        //276为bg的x坐标，20为bg的y坐标，30为bg的宽度，15为bg的高度，25为bgtitle的宽度
        _bgLabel.frame = CGRectMake(276-labelsize.width+30, 20, labelsize.width, 15);
        _bgLabel.text = bgArray[0];
    
        _bgTitleLabel.frame = CGRectMake(276-labelsize.width+30-25, 20, 25, 15);
    }
    //_departmentTitleLabel.text = @"部门";
    
//    //自动根据内容设置label的宽度
//    //设置城市的宽度
//    _locationLabel.numberOfLines = 0;
//    
//    _locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    _locationLabel.font = [UIFont systemFontOfSize:10];
//    CGSize locationLabelsize = [dict[@"work_location"] sizeWithFont:font constrainedToSize:size lineBreakMode:_locationLabel.lineBreakMode];
//    _locationLabel.frame = CGRectMake(185-locationLabelsize.width+100, 0, locationLabelsize.width, 21);
//    
//    
//    _locationTitleLabel.frame = CGRectMake(185-locationLabelsize.width+100-43, 0, 42, 21);
    
    //设置mail的宽度
    UIFont *font12 = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake(187,2000);
    CGSize mailTitleSize = [dict[@"e_mail"] sizeWithFont:font12 constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    _mailButton.frame = CGRectMake(27, 75, mailTitleSize.width, 15);
    [_mailButton setTitle:dict[@"e_mail"] forState:UIControlStateNormal];
    
    _mailUnderLineLabel.frame = CGRectMake(27, 90, mailTitleSize.width, 1);
    
    
    
}
- (IBAction)mailAction:(id)sender {
    NSString *mailStrin=[NSString stringWithFormat:@"mailto:%@",_mailButton.titleLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailStrin]];
    
    
}

@end
