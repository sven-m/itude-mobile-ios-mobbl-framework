/*
 * (C) Copyright Itude Mobile B.V., The Netherlands.
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

#import "MBDefaultBackButtonBuilder.h"
#import "MBApplicationFactory.h"
#import "MBLocalizationService.h"

// margin added to back button
#define kBackButtonMarginRight 7.0f
// padding added to back button
#define kBackButtonPadding 10.0f

@implementation MBDefaultBackButtonBuilder

- (UIBarButtonItem *)buildBackButton {
    return [self buildBackButtonWithTitle:nil];
}

- (UIBarButtonItem *)buildBackButtonWithTitle:(NSString *)title {
    UIButton *button = [[UIButton new] autorelease];
    [button addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Setup Image
    UIImage *image = [UIImage imageNamed:@"backButtonDefault.png"];
    image = [image stretchableImageWithLeftCapWidth:14.0f topCapHeight:0.0f];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    // Set a default title if none is given
    if (title.length == 0) {
        title = MBLocalizedString(@"Back");
    }
    
    // Setup the Font, Tekst and calculate button size
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    CGSize textSize = [title sizeWithFont:font];
    CGSize buttonSize = CGSizeMake(textSize.width + kBackButtonPadding * 2, image.size.height);
    [button setFrame:CGRectMake(0.0f, 0.0f, buttonSize.width, buttonSize.height)];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button.titleLabel setFont:font];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithRed:67.0f/255.0f green:3.0f/255.0f blue:38.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    CGFloat margin = floorf((button.frame.size.height - textSize.height) / 2);
    CGFloat marginRight = kBackButtonMarginRight;
    CGFloat marginLeft = button.frame.size.width - textSize.width - marginRight;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(margin, marginLeft, margin, marginRight)];
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}


#pragma mark -
#pragma mark Button Handeling

- (void)backButtonPressed:(id)sender {
    NSString *activePageStackName = [[[[MBApplicationController currentInstance] viewManager] dialogManager] activePageStackName];
    [[[[MBApplicationController currentInstance] viewManager] dialogManager] popPageOnPageStackWithName:activePageStackName];

}


@end
