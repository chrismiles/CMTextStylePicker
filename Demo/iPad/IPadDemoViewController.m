//
//  iPadDemoViewController.m
//  CMTextStylePickerDemo
//
//  Created by Chris Miles on 19/11/10.
//  Copyright (c) Chris Miles 2010.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "IPadDemoViewController.h"

@interface  IPadDemoViewController ()
@property (nonatomic, retain)	UIPopoverController	*currentPopoverController;
@property (nonatomic, retain)	UIFont				*defaultFont;
@property (nonatomic, retain)	UIColor				*defaultTextColor;
@end


@implementation IPadDemoViewController

@synthesize currentPopoverController, defaultFont, defaultTextColor;
@synthesize mainTextView;

- (IBAction)actionsButtonPressed:(id)sender {
	if (self.currentPopoverController) {
		[self.currentPopoverController dismissPopoverAnimated:YES];
		self.currentPopoverController = nil;
	}
	else {
		CMTextStylePickerViewController *textStylePickerViewController = [CMTextStylePickerViewController textStylePickerViewController];
		textStylePickerViewController.delegate = self;
		textStylePickerViewController.selectedTextColour = mainTextView.textColor;
		textStylePickerViewController.selectedFont = mainTextView.font;
		if ([mainTextView.textColor isEqual:defaultTextColor] && [mainTextView.font isEqual:defaultFont]) {
			textStylePickerViewController.defaultSettingsSwitchValue = YES;
		}
		else {
			textStylePickerViewController.defaultSettingsSwitchValue = NO;
		}
		
		UINavigationController *actionsNavigationController = [[[UINavigationController alloc] initWithRootViewController:textStylePickerViewController]
															   autorelease];
		
		Class classPopoverController = NSClassFromString(@"UIPopoverController");
		if (classPopoverController) {
			UIPopoverController *popoverController = [[[classPopoverController alloc] initWithContentViewController:actionsNavigationController]
													  autorelease];
			popoverController.delegate = self;
			[popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
									  permittedArrowDirections:UIPopoverArrowDirectionAny
													  animated:YES];
			
			self.currentPopoverController = popoverController;
		}
	}
}

- (void)resizeTextViewForKeyboard:(NSNotification *)aNotification up:(BOOL)up {
	NSDictionary* userInfo = [aNotification userInfo];
	
	// Get animation info from userInfo
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	
	CGRect keyboardEndFrame;
	
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	
	
	[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	
	
	// Animate up or down
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	
	CGRect newFrame = mainTextView.frame;
	CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
	
	if (up) {
		mainTextViewOriginalHeight = newFrame.size.height;
		newFrame.size.height -= keyboardFrame.size.height;
	}
	else {
		newFrame.size.height = mainTextViewOriginalHeight;
	}
	
	mainTextView.frame = newFrame;
	
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark CMTextStylePickerViewControllerDelegate methods

- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController userSelectedFont:(UIFont *)font {
	mainTextView.font = font;
}

- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController userSelectedTextColor:(UIColor *)textColor {
	mainTextView.textColor = textColor;
}

- (void)textStylePickerViewControllerSelectedCustomStyle:(CMTextStylePickerViewController *)textStylePickerViewController {
	// Use custom text style
	mainTextView.font = textStylePickerViewController.selectedFont;
	mainTextView.textColor = textStylePickerViewController.selectedTextColour;
}

- (void)textStylePickerViewControllerSelectedDefaultStyle:(CMTextStylePickerViewController *)textStylePickerViewController {
	// Use default text style
	mainTextView.font = self.defaultFont;
	mainTextView.textColor = self.defaultTextColor;
}

- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController replaceDefaultStyleWithFont:(UIFont *)font textColor:(UIColor *)textColor {
	self.defaultFont = font;
	self.defaultTextColor = textColor;
}


#pragma mark -
#pragma mark UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	self.currentPopoverController = nil;
}


#pragma mark -
#pragma mark Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self resizeTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
	[self resizeTextViewForKeyboard:aNotification up:NO]; 
}


#pragma mark -
#pragma mark UIViewController methods

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.defaultFont = mainTextView.font;
	self.defaultTextColor = mainTextView.textColor;
	
	// Subscribe to keyboard visible notifications (so we can adjust the text view scrollable area)
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];

    // Release any retained subviews of the main view.
	self.mainTextView = nil;
}


- (void)dealloc {
	[currentPopoverController release];
	[defaultFont release];
	[defaultTextColor release];
	[mainTextView release];
	
    [super dealloc];
}


@end
