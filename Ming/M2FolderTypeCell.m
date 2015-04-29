//
//  M2FolderTypeCell.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/18/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2FolderTypeCell.h"

@implementation M2FolderTypeCell{
    NSDictionary *_folderInfo;
    __weak IBOutlet UILabel *nameLabel;
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
    _folderInfo=dict;
    nameLabel.text=dict[@"name"];
}
@end
