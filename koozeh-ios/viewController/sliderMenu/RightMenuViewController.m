//
//  RightMenuViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 12/15/17.
//  Copyright © 2017 Anar. All rights reserved.
//

#import "RightMenuViewController.h"
#import "MessageUtil.h"
#import "RightMenuViewCell.h"
#import "SlideNavigationController.h"
#import "IssuesViewController.h"
#import "UIFont+FontUtil.h"
#import "UIColor+ColorUtil.h"
#import "MagazineCollectionViewController.h"
#import "BookmarksViewController.h"
#import "AboutViewController.h"
#import "UserProfileViewController.h"
#import "SupportViewController.h"

@interface RightMenuViewController ()

@property (strong, nonatomic) NSArray<NSString *> *menuIconImages;
@property (strong, nonatomic) NSArray<NSString *> *menuIconTitles;

@end

static NSInteger const ROW_HEIGHT = 46;

@implementation RightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.menuIconImages = [MessageUtil messagesForKey:@"menuIconImages"];
    self.menuIconTitles = [MessageUtil messagesForKey:@"menuIconTitles"];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat headerHeight = (self.view.frame.size.height - 200.0 - (ROW_HEIGHT * [self.tableView numberOfRowsInSection:0])) / 2;
    self.tableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, -headerHeight, 0);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuIconTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RightMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightMenuViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.menuIconImage = [self.menuIconImages objectAtIndex:indexPath.row];
    cell.menuIconTitle = [self.menuIconTitles objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        if (indexPath.row == 0) {
            if (![[SlideNavigationController sharedInstance].topViewController isKindOfClass:[IssuesViewController class]]) {
                for (UIViewController *viewController in [SlideNavigationController sharedInstance].viewControllers) {
                    if ([viewController isKindOfClass:[MagazineCollectionViewController class]]) {
                        [[SlideNavigationController sharedInstance] popToViewController:viewController animated:YES];
                        return;
                    }
                }
            }
        } else if (indexPath.row == 1) {
            for (UIViewController *viewController in [SlideNavigationController sharedInstance].viewControllers) {
                if ([viewController isKindOfClass:[BookmarksViewController class]]) {
                    [[SlideNavigationController sharedInstance] popToViewController:viewController animated:YES];
                    return;
                }
            }
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"bookmarksViewController"];
            [[SlideNavigationController sharedInstance] pushViewController:viewController animated:YES];
        } else if (indexPath.row == 2) {
            for (UIViewController *viewController in [SlideNavigationController sharedInstance].viewControllers) {
                if ([viewController isKindOfClass:[UserProfileViewController class]]) {
                    [[SlideNavigationController sharedInstance] popToViewController:viewController animated:YES];
                    return;
                }
            }
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"userProfileViewController"];
            [[SlideNavigationController sharedInstance] pushViewController:viewController animated:YES];
        } else if (indexPath.row == 3) {
            for (UIViewController *viewController in [SlideNavigationController sharedInstance].viewControllers) {
                if ([viewController isKindOfClass:[AboutViewController class]]) {
                    [[SlideNavigationController sharedInstance] popToViewController:viewController animated:YES];
                    return;
                }
            }
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutViewController"];
            [[SlideNavigationController sharedInstance] pushViewController:viewController animated:YES];
        } else if (indexPath.row == 4) {
            for (UIViewController *viewController in [SlideNavigationController sharedInstance].viewControllers) {
                if ([viewController isKindOfClass:[SupportViewController class]]) {
                    [[SlideNavigationController sharedInstance] popToViewController:viewController animated:YES];
                    return;
                }
            }
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"supportViewController"];
            [[SlideNavigationController sharedInstance] pushViewController:viewController animated:YES];
        }
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *versionString = [MessageUtil messageForKey:@"versionString"];
    UIFont *versionFont = [UIFont mainBoldFontWithSize:16.0];
    CGSize versionLabelSize = [UIFont labelSizeForString:versionString font:versionFont];
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, versionLabelSize.height, versionLabelSize.width)];
    NSDictionary *versionFontDictionary = @{NSFontAttributeName: versionFont, NSForegroundColorAttributeName: [UIColor menuIconColor]};
    NSMutableAttributedString *versionAttrString = [[NSMutableAttributedString alloc] initWithString:versionString attributes: versionFontDictionary];
    NSString *copyRightString = [NSString stringWithFormat:@"\r%@", [MessageUtil messageForKey:@"copyRightString"]];
//    UIFont *arialFont = [UIFont fontWithName:@"AmericanTypewriter" size:12.0];
    UIFont *arialFont = [UIFont systemFontOfSize:13.0];
    NSDictionary *arialFontDictionary = @{NSFontAttributeName: arialFont,
                                          NSForegroundColorAttributeName: [UIColor menuIconColor]};
    NSMutableAttributedString *copyRightAttrString = [[NSMutableAttributedString alloc] initWithString:copyRightString attributes: arialFontDictionary];
    [versionAttrString appendAttributedString:copyRightAttrString];
    versionLabel.numberOfLines = 3;
    versionLabel.attributedText = versionAttrString;
    versionLabel.textColor = [UIColor menuIconColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.frame = CGRectMake(0,0,
                                    versionLabel.frame.size.width,
                                    versionLabel.frame.size.height);
    return versionLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (self.view.frame.size.height - (ROW_HEIGHT * self.menuIconImages.count));
}

@end
