//
//  BokkmarksViewController.h
//  koozeh-ios
//
//  Created by Samin Safaei on 3/31/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bookmark.h"
#import "CustomTableViewController.h"

@protocol BookmarkDelegate

- (void)didSelectBookmark:(Bookmark *)bookmark;

@end
@interface BookmarksViewController : CustomTableViewController <BookmarkDelegate>

@end
