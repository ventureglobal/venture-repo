//
//  EditUserProfileViewController.m
//  koozeh-ios
//
//  Created by Samin Safaei on 4/3/18.
//  Copyright © 2018 Anar. All rights reserved.
//

#import "EditUserProfileViewController.h"
#import "MessageUtil.h"
#import "UIFont+FontUtil.h"
#import "UIColor+ColorUtil.h"
#import "UIViewUtil.h"
#import "UserManager.h"

@interface EditUserProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIPickerView *datePickerView;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *persianYears;
@property (strong, nonatomic) NSArray<NSString *> *persianMonth;
@property (strong, nonatomic) NSMutableArray<NSNumber *> *persianDays;
@property (copy, nonatomic) NSNumber *selectedBirthdateJalaliDay;
@property (copy, nonatomic) NSNumber *selectedBirthdateJalaliMonth;
@property (copy, nonatomic) NSNumber *selectedBirthdateJalaliYear;

@property (nonatomic) CGFloat currentOffset;

@end

@implementation EditUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentOffset = 0;
    // Do any additional setup after loading the view.
    self.saveButton.layer.borderWidth = 2.0;
    self.saveButton.layer.borderColor = [UIColor profileTitntColor].CGColor;
    self.saveButton.layer.cornerRadius = 8;
    self.cancelButton.layer.borderWidth = 2.0;
    self.cancelButton.layer.borderColor = [UIColor cancelColor].CGColor;
    self.cancelButton.layer.cornerRadius = 8;
    
    for (int i = 1300; i <= 1397; i++) {
        [self.persianYears addObject:@(i)];
    }
    self.persianMonth = [MessageUtil messagesForKey:@"persianMonth"];
    for (int i = 1; i <= 31; i++) {
        [self.persianDays addObject:@(i)];
    }
    
    self.firstNameTextField.tag = 1;
    self.lastNameTextField.tag = 2;
    self.datePickerView.tag = 3;
    self.emailTextField.tag = 4;
    
    [UIViewUtil addDoneButton:self.firstNameTextField target:self action:@selector(changeFirstResponder)];
    [UIViewUtil addDoneButton:self.lastNameTextField target:self action:@selector(changeFirstResponder)];
    [UIViewUtil addDoneButton:self.emailTextField target:self action:@selector(changeFirstResponder)];
    
    if (self.currentOffset != 0) {
        [self setViewOffset:self.currentOffset];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters and Setters
- (NSMutableArray<NSNumber *> *)persianYears {
    if (!_persianYears) {
        _persianYears = [NSMutableArray array];
    }
    return _persianYears;
}

- (NSMutableArray<NSNumber *> *)persianDays {
    if (!_persianDays) {
        _persianDays = [NSMutableArray array];
    }
    return _persianDays;
}

#pragma mark - Private Methods
- (void)reloadData {
    if (self.user.mobile != nil) {
        self.mobileLabel.text = self.user.mobile;
    }
    if (self.user.firstName != nil) {
        self.firstNameTextField.text = self.user.firstName;
    }
    if (self.user.lastName != nil) {
        self.lastNameTextField.text = self.user.lastName;
    }
    if (self.user.email != nil) {
        self.emailTextField.text = self.user.email;
    }
    if (self.user.birthdateJalaliDay != nil) {
        [self.datePickerView selectRow:[self.persianDays indexOfObject:self.user.birthdateJalaliDay] inComponent:0 animated:YES];
        self.selectedBirthdateJalaliDay = self.user.birthdateJalaliDay;
    }
    if (self.user.birthdateJalaliMonth != nil) {
        [self.datePickerView selectRow:([self.user.birthdateJalaliMonth integerValue] - 1) inComponent:1 animated:YES];
        self.selectedBirthdateJalaliMonth = self.user.birthdateJalaliMonth;
    }
    if (self.user.birthdateJalaliYear != nil) {
        [self.datePickerView selectRow:[self.persianYears indexOfObject:self.user.birthdateJalaliYear] inComponent:2 animated:YES];
        self.selectedBirthdateJalaliYear = self.user.birthdateJalaliYear;
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewOffset:(CGFloat)offset {
    if (self.currentOffset != 0 && offset != self.currentOffset) {
        [self setViewOffset:self.currentOffset];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
    rect.origin.y -= offset;
    rect.size.height += offset;
    self.view.frame = rect;
    self.currentOffset -= offset;
    
    [UIView commitAnimations];
}

- (void)changeFirstResponder {
    UIView *firstResponder = [self findFirstResponder];
    NSInteger nextTag = firstResponder.tag + 1;
    UIResponder* nextResponder = [firstResponder.superview viewWithTag:nextTag];
    if ([nextResponder isKindOfClass:UITextField.class]) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
        [self setViewOffset:((UITextField *)nextResponder).frame.origin.y - 280];
    } else {
        [firstResponder resignFirstResponder];
        [self setViewOffset:self.currentOffset];
    }
}

- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.view.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Action Methods
- (IBAction)saveAction:(id)sender {
    [self showOverlayActivityIndicator];
    self.user.firstName = self.firstNameTextField.text;
    self.user.lastName = self.lastNameTextField.text;
    self.user.email = self.emailTextField.text;
    self.user.birthdateJalaliDay = self.selectedBirthdateJalaliDay;
    self.user.birthdateJalaliMonth = self.selectedBirthdateJalaliMonth;
    self.user.birthdateJalaliYear = self.selectedBirthdateJalaliYear;
    [[UserManager sharedInstance] updateUser:self.user
                                     success:^(User *user) {
                                         [self reloadData];
                                         [self.navigationController popViewControllerAnimated:YES];
                                     } failure:^(NSError *error) {
                                         [UIViewUtil showUIAlertError:error fromController:self onClose:^{
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
                                     } messageBarDelegate:self];
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UITextFieldDelegate>
-(void)textFieldDidBeginEditing:(UITextField *)sender {
    if ([sender isEqual:self.emailTextField] || [sender isEqual:self.firstNameTextField] || [sender isEqual:self.lastNameTextField]) {
        //move the main view, so that the keyboard does not hide it.
        
        [self setViewOffset:sender.frame.origin.y - 280.0];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if ([nextResponder isKindOfClass:UITextField.class]) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
        [self setViewOffset:((UITextField *)nextResponder).frame.origin.y - 280.0];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self setViewOffset:self.currentOffset];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark - <UIPickerViewDataSource>
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.persianDays.count;
        case 1:
            return self.persianMonth.count;
        case 2:
        default:
            return self.persianYears.count;
    }
}

#pragma mark - <UIPickerViewDelegate>
// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat baseSize = (self.view.frame.size.width - 32.0) / 3.0;
    switch (component) {
        case 0:
            baseSize -= 20.0;
            break;
        case 1:
            baseSize += 20.0;
            break;
    }
    return baseSize;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont shabnamWithSize:24.0]];
    }
    // Fill the label text here
    switch (component) {
        case 0:
            tView.text = [NSString stringWithFormat:@"%@", self.persianDays[row]];
            [tView setTextAlignment:NSTextAlignmentRight];
            break;
        case 1:
            tView.text = self.persianMonth[row];
            [tView setTextAlignment:NSTextAlignmentCenter];
            break;
        case 2:
            tView.text = [NSString stringWithFormat:@"%@", self.persianYears[row]];
            [tView setTextAlignment:NSTextAlignmentLeft];
            break;
    }
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.selectedBirthdateJalaliDay = [NSNumber numberWithInteger:row + 1];
            break;
        case 1:
            self.selectedBirthdateJalaliMonth = [NSNumber numberWithInteger:row + 1];
            break;
        case 2:
            self.selectedBirthdateJalaliYear = self.persianYears[row];
            break;
        default:
            break;
    }
}


@end
