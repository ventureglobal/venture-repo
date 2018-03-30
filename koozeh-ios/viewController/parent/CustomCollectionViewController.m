//
//  CustomCollectionViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/7/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "CustomCollectionViewController.h"
#import "UIColor+ColorUtil.h"
#import "UIFont+FontUtil.h"
#import "PingManager.h"
#import "MessageUtil.h"

@interface CustomCollectionViewController ()

@property (strong, nonatomic) UITextView *messageBarTextView;
@property (strong, nonatomic) NSString *messageKey;

@end

@implementation CustomCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.collectionView= [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
