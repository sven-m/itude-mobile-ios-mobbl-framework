/*
 * (C) Copyright ItudeMobile.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "MBDatePickerController.h"
#import "MBDomainDefinition.h"
#import "MBDomainValidatorDefinition.h"
#import "MBViewBuilderFactory.h"
#import "MBStyleHandler.h"
#import "MBLocalizationService.h"
#import "StringUtilities.h"

@implementation MBDatePickerController

@synthesize datePickerView = _datePickerView;
@synthesize field = _field;
@synthesize datePickerMode = _datePickerMode;
@synthesize minimumDate = _minimumDate;
@synthesize maximumDate = _maximumDate;

// XML date format
#define XMLDATEFORMAT @"yyyy-MM-dd'T'HH:mm:ss"


#pragma mark -
#pragma mark Initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[[MBViewBuilderFactory sharedInstance].styleHandler applyStyle:_toolbar field:_field viewState: MBViewStatePlain];
	}
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MBStyleHandler *styler = [MBViewBuilderFactory sharedInstance].styleHandler;
	[styler styleToolbar:_toolbar];
	
    _cancelButton.title = MBLocalizedString(_cancelButton.title);
    _doneButton.title = MBLocalizedString(_doneButton.title);
    
    self.datePickerView.datePickerMode = self.datePickerMode;
    
    // Select the row of the untranslated Value. The title of the UIPickerView is translated. The value is not. JIRA: IQ-71
	NSString *currentValue = [_field untranslatedValue];
	NSDate *dateToSet = [NSDate date];
    if ([currentValue length] > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
        // TODO: Get Locale from settings
        //NSLocale *locale = [[NSLocale alloc] init];
        //[[MBLocalizationService sharedInstance] localeCode];
        //[dateFormatter setLocale:locale];
        
        // XML date format
        [dateFormatter setDateFormat:XMLDATEFORMAT];
        
        dateToSet = [dateFormatter dateFromString:currentValue];    
    }
    
    [_datePickerView setDate:dateToSet];
    
    if (self.minimumDate) {
        self.datePickerView.minimumDate = self.minimumDate;
    }
    
    if (self.maximumDate) {
        self.datePickerView.maximumDate = self.maximumDate;
    }
    
    // Adjust frame height for 4-inch screen (iPhone5)
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        CGRect r = self.view.frame;
        r.size.height = screenBounds.size.height;
        self.view.frame = r;
    }
}

#pragma mark -
#pragma mark IB actions

- (IBAction)cancel:(id)sender
{
	[self removeFromSuperviewWithAnimation];
}

- (IBAction)done:(id)sender
{
    
    NSDate *date = _datePickerView.date;
	
    [self removeFromSuperviewWithAnimation];
	
    NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
    // TODO: Get Locale from settings
    //NSLocale *locale = [[NSLocale alloc] init];
    //[[MBLocalizationService sharedInstance] localeCode];
    //[dateFormatter setLocale:locale];
    
    // XML date format
    [dateFormatter setDateFormat:XMLDATEFORMAT];
    
    NSString *fieldValue = [dateFormatter stringFromDate:date];
	[_field setValue: fieldValue];
}

#pragma mark -
#pragma mark Picker delegate


#pragma mark -
#pragma mark Animation

// add our view to superview, and slide it in from the bottom
- (void)presentWithSuperview:(UIView *)superview {
	
    // set initial location at bottom of superview
    CGRect r = self.view.frame;
    r.origin = CGPointMake(0.0, superview.bounds.size.height);
    self.view.frame = r;
	
	[superview addSubview:self.view];
	
    // animate to new location
    [UIView beginAnimations:@"presentWithSuperview" context:nil];
    r.origin = CGPointZero;
    self.view.frame = r;
    [UIView commitAnimations];
    
}

// called when removeFromSuperviewWithAnimation's animation completes
- (void)animationDidStop:(NSString *)animationID
                finished:(NSNumber *)finished
                 context:(void *)context {
    if ([animationID isEqualToString:@"removeFromSuperviewWithAnimation"]) {
        [self.view removeFromSuperview];
    }
}

// slide this view to bottom of superview, then remove from superview
- (void)removeFromSuperviewWithAnimation {
	
    [UIView beginAnimations:@"removeFromSuperviewWithAnimation" context:nil];
	
    // set delegate and selector to remove from superview when animation completes
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
    // Move this view to bottom of superview
    CGRect r = self.view.frame;
    r.origin = CGPointMake(0.0, self.view.superview.bounds.size.height);
    self.view.frame = r;
	
    [UIView commitAnimations];    
}




@end