//
//  M2AssetCell.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/17/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2AssetCell.h"

@interface M2AssetCell ()
@property (weak, nonatomic) IBOutlet UILabel *assetTypeName;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *assetId;
@property (weak, nonatomic) IBOutlet UILabel *assetIdTitle;
@property (weak, nonatomic) IBOutlet UILabel *storeCity;
@property (weak, nonatomic) IBOutlet UILabel *storageDate;
@property (weak, nonatomic) IBOutlet UILabel *monthlyDepreciationLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (weak, nonatomic) IBOutlet UILabel *monthlyDepreciationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusTitileLabel;

@end

@implementation M2AssetCell{
    NSDictionary *_assetDict;
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
    _assetDict=dict;
    _assetTypeName.text=dict[@"AssetTypeName"];
    _company.text=dict[@"Company"];
    _codeLabel.text=dict[@"AssetId"];
    _storeCity.text=dict[@"StoreCity"];
    
    NSString *dateString=dict[@"StorageDate"];
    NSLog(@"开始日期%@",dateString);
    //dateString=[dateString substringToIndex:dateString.length-3];
    //NSLog(@"开始日期%@",dateString);
    //    NSLog(@"%@",dateString);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    //[formatter setDateFormat:@"yyyy-MM-dd"];
    //[formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *storeDate=[formatter dateFromString:dateString];
    NSLog(@"开始日期%@",storeDate);
    formatter.dateFormat = @"yyyy-MM-dd";
    _storageDate.text=[formatter stringFromDate:storeDate];
    
    //    float depreciationValue=[dict[@"MonthlyDepreciation"] floatValue];
    //    float priceValue=[dict[@"Price"] floatValue];
    //    float surplusValue=[dict[@"SurplusValue"] floatValue];
    
    _monthlyDepreciationLabel.text=dict[@"MonthlyDepreciation"];
    _surplusLabel.text=dict[@"SalvageValue"];
    
    _assetId.text=dict[@"LocalCode"];
    
    //自动根据内容设置label的宽度
    //设置设备id的宽度
    _assetId.numberOfLines = 0;
    
    _assetId.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont systemFontOfSize:12];
    _assetId.font = [UIFont systemFontOfSize:12];
    
    CGSize size = CGSizeMake(187,2000);
    CGSize labelsize = [dict[@"LocalCode"] sizeWithFont:font constrainedToSize:size lineBreakMode:_assetId.lineBreakMode];
    _assetId.frame = CGRectMake(219-labelsize.width+80, 0, labelsize.width, 15);
    _assetId.text = dict[@"LocalCode"];
    
    _assetIdTitle.frame = CGRectMake(219-labelsize.width+80-90, 0, 90, 15);
    
    //自动根据内容设置label的宽度
    //设置每月折旧值的宽度
    _monthlyDepreciationLabel.numberOfLines = 0;
    
    _monthlyDepreciationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _monthlyDepreciationLabel.font = [UIFont systemFontOfSize:12];
    CGSize locationLabelsize = [dict[@"MonthlyDepreciation"] sizeWithFont:font constrainedToSize:size lineBreakMode:_monthlyDepreciationLabel.lineBreakMode];
    _monthlyDepreciationLabel.frame = CGRectMake(219-locationLabelsize.width+80, 19, locationLabelsize.width, 15);
    _monthlyDepreciationLabel.text = dict[@"MonthlyDepreciation"];
    
    _monthlyDepreciationTitleLabel.frame = CGRectMake(219-locationLabelsize.width+80-120, 19, 120, 15);
    
    //自动根据内容设置label的宽度
    //设置每月折旧值的宽度
    _surplusLabel.numberOfLines = 0;
    
    _surplusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _surplusLabel.font = [UIFont systemFontOfSize:12];
    CGSize surplusLabelLabelsize = [dict[@"SalvageValue"] sizeWithFont:font constrainedToSize:size lineBreakMode:_surplusLabel.lineBreakMode];
    _surplusLabel.frame = CGRectMake(219-surplusLabelLabelsize.width+80, 38, surplusLabelLabelsize.width, 15);
    _surplusLabel.text = dict[@"SalvageValue"];
    
    _surplusTitileLabel.frame = CGRectMake(219-surplusLabelLabelsize.width+80-79, 38, 79, 15);
}

@end
