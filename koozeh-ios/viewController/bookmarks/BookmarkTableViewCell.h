//
//  BookmarkTableViewCell.h
//  koozeh-ios
//
//  Created by Samin Safaei on 4/2/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bookmark.h"
#import "Issue.h"
#import "BookmarksViewController.h"

@interface BookmarkTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) Issue *issue;
@property (weak, nonatomic) NSMutableArray<Bookmark *> *bookmarks;
@property (weak, nonatomic) id<BookmarkDelegate> bookmarkDelegate;

@end
