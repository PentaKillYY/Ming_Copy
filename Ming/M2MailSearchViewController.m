//
//  M2MailSearchViewController.m
//  Ming2.0
//
//  Created by xiaoweiwu on 13-12-11.
//  Copyright (c) 2013年 xiaowei wu. All rights reserved.
//

#import "M2MailSearchViewController.h"
#import "M2MailSearchCell.h"
#import "M2UtilityParser.h"
#import "UITableView+CustomAnimation.h"
#import "M2SearchHUD.h"
#import <SVProgressHUD.h>
#define kMailCellIdentifier  @"MailCellIdentifier"

@interface M2MailSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSMutableArray *_resultArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UILabel *resultCountLabel;
@property (weak, nonatomic) IBOutlet UIView *headerBtmLine;

@end

@implementation M2MailSearchViewController{
    M2SearchHUD *searchHUD;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=NSLocalizedString(@"人员查找", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *nib=[UINib nibWithNibName:@"M2MailSearchCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:kMailCellIdentifier];
    
    _resultArray=[NSMutableArray array];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downTextField)];
    [self.tableView addGestureRecognizer:tap];
    
   
//    [searchHUD show];
    
}

-(void)downTextField
{
    [self.searchField resignFirstResponder];

}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    searchHUD=[M2SearchHUD sharedHUD];
    searchHUD.center=self.view.center;
    [self.view addSubview:searchHUD];
    [[M2SearchHUD sharedHUD] showInView:self.view status:kReady];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark =======table view delegate=======
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_resultArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    M2MailSearchCell *mailCell=[tableView dequeueReusableCellWithIdentifier:kMailCellIdentifier];
    
    if(indexPath.row >= 0 && [indexPath row] % 2 == 0){
        //单数行的背景设置为灰色
        mailCell.backgroundColor = [UIColor colorWithRed:241.0/255 green:245.0/255 blue:248.0/255 alpha:1.0f];
    }else if(indexPath.row >= 0 && [indexPath row] % 2 == 1){
        //复数行设置为白色
        mailCell.backgroundColor = [UIColor whiteColor];
    }
    
    [mailCell setCellWithDict:_resultArray[[indexPath row]]];
    return mailCell;
}


#pragma mark===== text Field delegate====
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"hit search");
//    [textField resignFirstResponder];
    [self searchAction:nil];
    return YES;
}

/**
 *  搜索Action
 *
 *  @param sender button
 */

- (IBAction)searchAction:(id)sender {
    [self.searchField resignFirstResponder];
    
    if (!self.searchField.text||[self.searchField.text isEqualToString:@""]) {
        return;
    }
    
    NSRegularExpression *regular=[NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5]" options:0 error:nil];
    NSString *searchText=self.searchField.text;
    NSRange range=NSMakeRange(0, searchText.length);
    NSArray *matches=[regular matchesInString:searchText options:0 range:range];
    
    if (matches.count>0) {
        if (searchText.length<2) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"stringNotEnoughCH", @"")];
            return;
        }
    }else{
        NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
        s=[s invertedSet];
        
        NSRange r=[self.searchField.text rangeOfCharacterFromSet:s];
        
        if (r.location != NSNotFound) {
            NSLog(@"the string contains illegal characters");
        }else{
            if (self.searchField.text.length <3) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"stringNotEnough", @"")];
                return;
            }
        }

    }
    

                           
    
    
    [searchHUD show];
    
    NSString *searchString=[self.searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    [[M2UtilityParser sharedParser]getEmployeeInfoWithKeyWord:searchString onCompletion:^(NSArray *json) {
        NSLog(@"mail search response:%@",json);
        _resultCountLabel.text=[NSString stringWithFormat:@"%d%@",(int)json.count,NSLocalizedString(@"结果", @"")];
        
        _resultCountLabel.hidden=NO;
        _headerBtmLine.hidden=NO;
        
//        _resultArray=[json mutableCopy];
//        [self.tableView reloadData];
        
        
        if (_resultArray.count>0) {
            [self deleteRowsWithJson:json];
        }else{
            [self addRowsWithJson:json];
        }
        
    }];
}

/**
 *  加载搜索结果
 *
 *  @param json 返回数据json
 */

-(void)addRowsWithJson:(NSArray *)json{
    for (int i=0; i<MIN(6, json.count); i++) {
        double delayInSeconds = i*0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (i==5) {
                _resultArray=[json mutableCopy];
                [self.tableView reloadData];
            }else{
                NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_resultArray addObject:json[i]];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade|UITableViewRowAnimationLeft];
            }
        });
    }

}


/**
 *  删除行
 *
 *  @param json 数据json
 */

-(void)deleteRowsWithJson:(NSArray *)json{
    if (_resultArray.count>6) {
        [_resultArray removeObjectsInRange:NSMakeRange(6, _resultArray.count-6)];
        [self.tableView reloadData];
    }

    for (NSInteger i=_resultArray.count-1; i>=0; i--) {
        double delayInSeconds =(_resultArray.count-1-i)*0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_resultArray removeObjectAtIndex:i];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
            if (i==0) {
                [self addRowsWithJson:json];
            }
        });
    }
    
}


@end
