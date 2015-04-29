//
//  M2ResourcesLibraryController.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/18/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2ResourcesLibraryController.h"
#import "M2SeachBarView.h"
#import "M2UtilityParser.h"
#import "M2FileTypeCell.h"
#import "M2FolderTypeCell.h"
#import "M2SearchHeaderView.h"
#import "M2SearchHUD.h"
#import "M2ResourceDetailController.h"

@import MediaPlayer;

#define kFileTypeCellIdentifier @"FileTypeCell"
#define kFolderTypeCellIdentifier @"FolderTypeCell"

@interface M2ResourcesLibraryController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet M2SearchHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong,nonatomic) NSMutableArray *resultArray;
@property (strong,nonatomic) NSMutableArray *backupArray;
@end

@implementation M2ResourcesLibraryController{
    CGRect searchFrame;
    BOOL isInsearch;
    BOOL fullLoaded;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=NSLocalizedString(@"文档", @"");
        [self setTabBarItemWithImage:[UIImage imageNamed:@"doc_icon"] withSelectedImage:[UIImage imageNamed:@"doc_icon_sel"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIView *searchContainer=[self.headerView viewWithTag:11];
    searchFrame=searchContainer.frame;
    
    _resultArray=[NSMutableArray array];
    
    if (self.folderPath) {
        [[M2UtilityParser sharedParser]getShareFileWithFolderPath:self.folderPath OnCompletion:^(NSArray *json) {
            [self addRowsWithJson:json];
            self.backupArray=[json mutableCopy];
        }];
    }else{
        [[M2UtilityParser sharedParser] getSharedFileOnCompletion:^(NSArray *json) {
            [self addRowsWithJson:json];
            self.backupArray=[json mutableCopy];
        }];
    }
    
    UINib *fileNib=[UINib nibWithNibName:@"M2FileTypeCell" bundle:nil];
    UINib *folderNib=[UINib nibWithNibName:@"M2FolderTypeCell" bundle:nil];
    
    [self.tableView registerNib:fileNib forCellReuseIdentifier:kFileTypeCellIdentifier];
    [self.tableView registerNib:folderNib forCellReuseIdentifier:kFolderTypeCellIdentifier];
    
    double delayInSeconds = 0.05;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    });
}

-(void)updateNavBarItem{
    if (self.folderPath) {
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
    }else{
        [super updateNavBarItem];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateNavigationBar{
    [super updateNavigationBar];
    if (isInsearch) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark=====text Field delegate=======

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    isInsearch=YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.headerView.fakeNavView.hidden=NO;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.headerView.isNavHidden=YES;
        [self.headerView layoutSubviews];
    } completion:^(BOOL finished) {
        self.tableView.scrollEnabled=NO;
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    [[M2SearchHUD sharedHUD]showInView:self.view status:kSearch];
    
    [[M2UtilityParser sharedParser] searchFileWithKeyWord:textField.text onCompletion:^(NSArray *json) {
        [self deleteRowsWithJson:json];
        [[M2SearchHUD sharedHUD] dismiss];
        self.tableView.scrollEnabled=YES;
    }];
    
    return YES;
}

/**
 *  取消搜索
 *
 *  @param sender button
 */
- (IBAction)dismissSearchAction:(id)sender {
    [_searchField resignFirstResponder];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.headerView.isNavHidden=NO;
        [self.headerView layoutSubviews];
    } completion:^(BOOL finished) {
        self.tableView.scrollEnabled=YES;
        self.headerView.fakeNavView.hidden=YES;
    }];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    isInsearch=NO;
    [[M2SearchHUD sharedHUD] dismiss];
    [[M2SearchHUD sharedHUD] removeFromSuperview];
    
    if (fullLoaded) {
        [self deleteRowsWithJson:_backupArray];
    }
}

/**
 *  搜索
 *
 *  @param sender button
 */
- (IBAction)searchAction:(id)sender {
    if (isInsearch) {
        isInsearch=NO;
        [self.searchField resignFirstResponder];
        
        [[M2SearchHUD sharedHUD]showInView:self.view status:kSearch];
        
        [[M2UtilityParser sharedParser] searchFileWithKeyWord:self.searchField.text onCompletion:^(NSArray *json) {
            [self deleteRowsWithJson:json];
            if([json count]==0){
                [self.view makeToast:NSLocalizedString(@"noFound", @"") duration:1.0 position:@"center"];
            }
            
            [[M2SearchHUD sharedHUD] dismiss];
            self.tableView.scrollEnabled=YES;
        }];
        
    }else{
        [self.searchField becomeFirstResponder];
    }
}


#pragma mark ======tableview delegate======
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_resultArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row=[indexPath row];
    NSString *isFile=_resultArray[row][@"is_file"];
                                       
    
    if ([isFile isEqualToString:@"0"]) {
        M2FolderTypeCell *folderTypeCell=[tableView dequeueReusableCellWithIdentifier:kFolderTypeCellIdentifier];
        [folderTypeCell setCellWithDict:_resultArray[row]];
        return folderTypeCell;
    }else{
        M2FileTypeCell *fileTypeCell=[tableView dequeueReusableCellWithIdentifier:kFileTypeCellIdentifier];
        [fileTypeCell setCellWithDict:_resultArray[row]];
        return fileTypeCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row=[indexPath row];
    NSString *isFile=_resultArray[row][@"is_file"];
    
    
    if ([isFile isEqualToString:@"1"]) {
        if ([_resultArray[row][@"ext"] isEqualToString:@".mp4"]||[_resultArray[row][@"ext"] isEqualToString:@".mpg"]||[_resultArray[row][@"ext"] isEqualToString:@".wmv"]||[_resultArray[row][@"ext"] isEqualToString:@".mov"]||[_resultArray[row][@"ext"] isEqualToString:@".MOV"]) {
            [self playVidewWithUrl:_resultArray[row][@"url"]];
        }else{
            M2ResourceDetailController *resourceDetail=[[M2ResourceDetailController alloc]init];
            resourceDetail.fileInfo=_resultArray[row];
            [self.navigationController pushViewController:resourceDetail animated:YES];
        }
        [[M2UtilityParser sharedParser] addFileLogForUrl:_resultArray[row][@"url"]];
    }else{
        M2ResourcesLibraryController *folderController=[[M2ResourcesLibraryController alloc]init];
        folderController.folderPath=_resultArray[row][@"path"];
        [self.navigationController pushViewController:folderController animated:YES];
    }
}

/**
 *  播放视屏
 *
 *  @param urlStr URL
 */
-(void)playVidewWithUrl:(NSString *)urlStr{
   MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:urlStr]];
    [self presentMoviePlayerViewControllerAnimated:mp];
    [[mp moviePlayer] prepareToPlay];
    [mp moviePlayer].shouldAutoplay=YES;
    [mp.moviePlayer play];
}

/**
 *  加载数据
 *
 *  @param json json
 */
-(void)addRowsWithJson:(NSArray *)json{
    for (int i=0; i<MIN(12, json.count); i++) {
        fullLoaded=NO;
        double delayInSeconds = i*0.12;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (i==json.count-1) {
                fullLoaded=YES;
            }
            
            if (i==11) {
                _resultArray=[json mutableCopy];
                [self.tableView reloadData];
                fullLoaded=YES;
            }else{
                NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_resultArray addObject:json[i]];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            }
        });
    }
}


/**
 *  删除数据
 *
 *  @param json Json
 */
-(void)deleteRowsWithJson:(NSArray *)json{
//    if (_resultArray.count>11) {
//        [_resultArray removeObjectsInRange:NSMakeRange(11, _resultArray.count-11)];
//        [self.tableView reloadData];
//    }
//    
//    if (_resultArray.count==0) {
//        [self addRowsWithJson:json];
//    }else{
//        for (NSInteger i=_resultArray.count-1; i>=0; i--) {
//            double delayInSeconds =(_resultArray.count-1-i)*0.1;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            self.backBarButtonItem.hidden=YES;
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                [_resultArray removeObjectAtIndex:i];
//                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
//                if (i==0) {
//                    [self addRowsWithJson:json];
//                }
//            });
//        }
//    }
//
    _resultArray=[NSMutableArray array];
    [self.tableView reloadData];
    [self addRowsWithJson:json];
}

@end
