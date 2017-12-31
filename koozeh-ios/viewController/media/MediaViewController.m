//
//  MediaViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/19/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "MediaViewController.h"
#import "SessionManager.h"
@import AVFoundation;
@import AVKit;

@interface MediaViewController ()

@end

@implementation MediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.media) {
        if ([@"VIDEO" isEqualToString:self.media.mediaType]) {
            [self reloadVideo];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)reloadVideo {
    // grab a local URL to our video
    NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseStorageURL, self.media.url]];
    
    // create an AVPlayer
    AVPlayer *player = [AVPlayer playerWithURL:videoURL];
    
    // create a player view controller
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    controller.player = player;
    [player play];
    
    // show the view controller
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    controller.view.frame = self.view.frame;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
