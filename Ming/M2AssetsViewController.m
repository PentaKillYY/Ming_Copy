//
//  M2AssetsViewController.m
//  Ming2.0
//
//  Created by xiaoweiwu on 12/17/13.
//  Copyright (c) 2013 xiaowei wu. All rights reserved.
//

#import "M2AssetsViewController.h"
#import "M2AssetCell.h"
#import "M2UtilityParser.h"
#import "M2SearchHUD.h"
#define kAssetCellIdentifier @"AssetCellIdentifier"




@interface M2AssetsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_resultArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation M2AssetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=NSLocalizedString(@"个人资产", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _resultArray=[NSMutableArray array];
    
    
    
    UINib *nib=[UINib nibWithNibName:@"M2AssetCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:kAssetCellIdentifier];
    
    
    [[M2UtilityParser sharedParser] getEmployeeAssetOnCompletion:^(NSArray *json) {
        [self addRowsWithJson:json];
//        [self.tableView reloadData];
    }];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [[M2SearchHUD sharedHUD] showInView:self.view status:kSearch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark =====table view delegate=====
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    M2AssetCell *assetCell=[tableView dequeueReusableCellWithIdentifier:kAssetCellIdentifier];
    
    if(indexPath.row >= 0 && [indexPath row] % 2 == 0){
        //单数行的背景设置为灰色
        assetCell.backgroundColor = [UIColor colorWithRed:241.0/255 green:245.0/255 blue:248.0/255 alpha:1.0f];
    }else if(indexPath.row >= 0 && [indexPath row] % 2 == 1){
        //复数行设置为白色
        assetCell.backgroundColor = [UIColor whiteColor];
    }
    
    [assetCell setCellWithDict:_resultArray[indexPath.row]];
    return assetCell;
}


//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    CABasicAnimation *fadeIn=[CABasicAnimation animationWithKeyPath:@"opacity"];
//    fadeIn.fromValue=@0;
//    fadeIn.toValue=@1;
//    fadeIn.duration=1;
//    [cell.layer addAnimation:fadeIn forKey:@"fadeIn"];
//}

/**
 *  加载搜索结果
 *
 *  @param json 返回数据json
 */


-(void)addRowsWithJson:(NSArray *)json{
    for (int i=0; i<MIN(6, json.count); i++) {
        double delayInSeconds = i*0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (i==5) {
                _resultArray=[json mutableCopy];
                [self.tableView reloadData];
            }else{
                NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_resultArray addObject:json[i]];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                
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
