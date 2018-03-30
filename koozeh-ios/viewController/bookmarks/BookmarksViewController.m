//
//  BokkmarksViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 3/31/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "BookmarksViewController.h"
#import "Bookmark.h"
#import "BookmarkManager.h"
#import "UIViewUtil.h"
#import "LoginViewController.h"
#import "BookmarkTableViewCell.h"
#import "PageSliderViewController.h"

@interface BookmarksViewController ()

@property (strong, nonatomic) NSArray<Bookmark *> *bookmarks;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *bookmarkMagazineIds;
@property (strong, nonatomic) NSMutableArray<Magazine *> *bookmarkMagazines;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *currentIssueIds;
@property (strong, nonatomic) NSMutableArray<Issue *> *currentIssues;
@property (strong, nonatomic) NSMutableArray<NSMutableArray<Bookmark *> *> *currentIssuesBookmarks;
@property (nonatomic) NSInteger selectedMagazine;
@property (weak, nonatomic) Bookmark *currentSelectedBookmark;

@end

@implementation BookmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"userToken"] == nil) {
        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[LoginViewController class]]) {
                [self.navigationController popToViewController:viewController animated:YES];
                return;
            }
        }
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
    } else {
        [[BookmarkManager sharedInstance] getAllBookmarks:^(NSArray<Bookmark *> *bookmarks) {
            self.bookmarks = bookmarks;
        } failure:^(NSError *error) {
            if (error.userInfo != nil && [@"Unauthorize" isEqualToString:error.userInfo[@"errorKey"]]) {
                [UIViewUtil showUIAlertError:error
                              fromController:self
                                        onOk:^{
                                            for (UIViewController *viewController in self.navigationController.viewControllers) {
                                                if ([viewController isKindOfClass:[LoginViewController class]]) {
                                                    [self.navigationController popToViewController:viewController animated:YES];
                                                    return;
                                                }
                                            }
                                            [self performSegueWithIdentifier:@"showLogin" sender:nil];
                                        } onCancel:^{
                                            //Do nothing
                                        }];
            }
        } messageBarDelegate:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters and Setters
- (void)setBookmarks:(NSArray<Bookmark *> *)bookmarks {
    _bookmarks = bookmarks;
    _bookmarkMagazines = nil;
    _bookmarkMagazineIds = nil;
    _currentIssues = nil;
    _currentIssueIds = nil;
    _currentIssuesBookmarks = nil;
    self.selectedMagazine = 0;
    for (Bookmark *bookmark in bookmarks) {
        if (![self.bookmarkMagazineIds containsObject:[NSNumber numberWithLong:bookmark.magazine.id]]) {
            [self.bookmarkMagazineIds addObject:[NSNumber numberWithLong:bookmark.magazine.id]];
            [self.bookmarkMagazines addObject:bookmark.magazine];
        }
        if (bookmark.magazine.id == [self.bookmarkMagazineIds[0] longValue]) {
            NSInteger issueArrayIndex;
            if (![self.currentIssueIds containsObject:[NSNumber numberWithLong:bookmark.issue.id]]) {
                [self.currentIssueIds addObject:[NSNumber numberWithLong:bookmark.issue.id]];
                [self.currentIssues addObject:bookmark.issue];
                issueArrayIndex = self.currentIssues.count - 1;
                [self.currentIssuesBookmarks addObject:[NSMutableArray array]];
            } else {
                issueArrayIndex = [self.currentIssueIds indexOfObject:[NSNumber numberWithLong:bookmark.issue.id]];
            }
            NSMutableArray<Bookmark *> *bookmarks = self.currentIssuesBookmarks[issueArrayIndex];
            [bookmarks addObject:bookmark];
        }
        
    }
    [self.tableView reloadData];
}

- (NSMutableArray<NSNumber *> *)bookmarkMagazineIds {
    if (!_bookmarkMagazineIds) {
        _bookmarkMagazineIds = [NSMutableArray array];
    }
    return _bookmarkMagazineIds;
}

- (NSMutableArray<Magazine *> *)bookmarkMagazines {
    if (!_bookmarkMagazines) {
        _bookmarkMagazines = [NSMutableArray array];
    }
    return _bookmarkMagazines;
}

- (NSMutableArray<NSNumber *> *)currentIssueIds {
    if (!_currentIssueIds) {
        _currentIssueIds = [NSMutableArray array];
    }
    return _currentIssueIds;
}

- (NSMutableArray<Issue *> *)currentIssues {
    if (!_currentIssues) {
        _currentIssues = [NSMutableArray array];
    }
    return _currentIssues;
}

- (NSMutableArray<NSMutableArray<Bookmark *> *> *)currentIssuesBookmarks {
    if (!_currentIssuesBookmarks) {
        _currentIssuesBookmarks = [NSMutableArray array];
    }
    return _currentIssuesBookmarks;
}

#pragma mark - <BookmarkDelegate>
- (void)didSelectBookmark:(Bookmark *)bookmark {
    self.currentSelectedBookmark = bookmark;
    [self performSegueWithIdentifier:@"showBookmark" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentIssues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookmarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.bookmarks = self.currentIssuesBookmarks[indexPath.row];
    cell.issue = self.currentIssues[indexPath.row];
    cell.bookmarkDelegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.frame.size.width / 4;
    return ((409.0 / 305.0) * width) + 60.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"showBookmark" isEqualToString:segue.identifier]) {
        PageSliderViewController *pageSliderViewController = segue.destinationViewController;
        pageSliderViewController.magazine = self.currentSelectedBookmark.magazine;
        pageSliderViewController.issue = self.currentSelectedBookmark.issue;
        pageSliderViewController.magazineName = self.currentSelectedBookmark.magazine.name;
        pageSliderViewController.issueVolume = self.currentSelectedBookmark.issue.issueNumber;
        pageSliderViewController.pageToShow = self.currentSelectedBookmark.page;
        self.currentSelectedBookmark = nil;
    }
}

@end
