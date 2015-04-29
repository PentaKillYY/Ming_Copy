//
//  M2FileTypeCell.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/18/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2FileTypeCell.h"
#import "NSString+Date.h"

@implementation M2FileTypeCell{
    
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UIImageView *typeImageView;
    __weak IBOutlet UILabel *sizeDatelabel;
    
    NSDictionary *fileInfoDict;
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
    self.backgroundColor=[UIColor clearColor];
    NSString *extention=[[dict objectForKey:@"ext"] lowercaseString];
    if ([extention isEqualToString:@".png"]||[extention isEqualToString:@".jpg"]||[extention isEqualToString:@".gif"]) {
        typeImageView.image=[UIImage imageNamed:@"file_images_normal@2x"];
    }else if ([extention isEqualToString:@".txt"]){
        typeImageView.image=[UIImage imageNamed:@"file_txtfile_icon@2x"];
    }else if ([extention isEqualToString:@".pdf"]){
        typeImageView.image=[UIImage imageNamed:@"file_pdf_icon@2x"];
    }else if([extention isEqualToString:@".xls"]||[extention isEqualToString:@".xlsx"]){
        typeImageView.image=[UIImage imageNamed:@"file_excel_icon@2x"];
    }else if ([extention isEqualToString:@".docx"]||[extention isEqualToString:@".doc"]){
        typeImageView.image=[UIImage imageNamed:@"file_doc_icon@2x"];
    }else if([extention isEqualToString:@".pptx"]||[extention isEqualToString:@".ppt"]){
        typeImageView.image=[UIImage imageNamed:@"file_ppt_icon@2x"];
    }else if([extention isEqualToString:@".zip"]||[extention isEqualToString:@".rar"]){
        typeImageView.image=[UIImage imageNamed:@"file_compressFile_icon@2x"];
    }else if([extention isEqualToString:@".mp4"]||[extention isEqualToString:@".mov"]){
        typeImageView.image=[UIImage imageNamed:@"file_videofile_icon@2x"];
    }else{
        typeImageView.image=[UIImage imageNamed:@"file_unknown_icon@2x"];
    }

    
    nameLabel.text=dict[@"name"];
    
//    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
//    NSDate *uploadDate=[formatter dateFromString:dict[@"upload_time"]];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *dateString=[formatter stringFromDate:uploadDate];
    NSString *dateString=[dict[@"upload_time"] getYearString];
    
    
    CGFloat byteSize=[dict[@"size"] floatValue];
    CGFloat kBSize=byteSize/1024;
    CGFloat mBSize=kBSize/1024;
    
    if(mBSize>1.0){
        sizeDatelabel.text=[NSString stringWithFormat:@"%.1fM,%@上传",mBSize,dateString];
    }else{
        sizeDatelabel.text=[NSString stringWithFormat:@"%.1fK,%@上传",kBSize,dateString];
    }
    
//    sizeDatelabel.text=[NSString stringWithFormat:@"%@,%@上传",dict[@"size"],dateString];
}

@end
