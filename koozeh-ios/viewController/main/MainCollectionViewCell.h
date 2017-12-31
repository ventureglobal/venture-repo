//
//  MainCollectionViewCell.h
//  koozeh-ios
//
//  Created by Samin Safaei on 12/11/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Issue.h"

@interface MainCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) Issue *issue;
@property (nonatomic) NSInteger issueVolume;

@end
