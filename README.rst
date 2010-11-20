CMTextStylePicker
=================

iOS view controller tree for presenting a text font/size/colour picker to user.

It is also possible to use the font or colour selectors separately.

A universal (iPhone/iPad) demo app is included with the source.


Screenshots
-----------

|ipad_demo| |iphone_demo|

.. |ipad_demo| image:: http://farm5.static.flickr.com/4128/5191609858_76368e3041.jpg
.. |iphone_demo| image:: http://farm5.static.flickr.com/4089/5191609788_5f38a0393c.jpg


Usage
-----

CMTextStylePickerViewController is the main class.  It is designed to
be added to a UINavigationController, either at the root or pushed
on to the navigation tree.  The UINavigationController would typically
be presented as a modal view controller on the iPhone or within a
UIPopoverController on the iPad.

Example::

  CMTextStylePickerViewController *textStylePickerViewController = [CMTextStylePickerViewController textStylePickerViewController];
  textStylePickerViewController.delegate = self;
  textStylePickerViewController.selectedTextColour = aTextView.textColor;
  textStylePickerViewController.selectedFont = aTextView.font;
  if ([aTextView.textColor isEqual:defaultTextColor] && [aTextView.font isEqual:defaultFont]) {
    textStylePickerViewController.defaultSettingsSwitchValue = YES;
  }
  else {
    textStylePickerViewController.defaultSettingsSwitchValue = NO;
  }
  
  UINavigationController *actionsNavigationController = [[[UINavigationController alloc] initWithRootViewController:textStylePickerViewController] autorelease];


The delegate should implement the CMTextStylePickerViewControllerDelegate protocol.

CMTextStylePickerViewControllerDelegate callback examples::

  - (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController userSelectedFont:(UIFont *)font {
    aTextView.font = font;
  }
  
  - (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController userSelectedTextColor:(UIColor *)textColor {
    aTextView.textColor = textColor;
  }

  - (void)textStylePickerViewControllerSelectedCustomStyle:(CMTextStylePickerViewController *)textStylePickerViewController {
    // Use custom text style
    aTextView.font = textStylePickerViewController.selectedFont;
    aTextView.textColor = textStylePickerViewController.selectedTextColour;
  }

  - (void)textStylePickerViewControllerSelectedDefaultStyle:(CMTextStylePickerViewController *)textStylePickerViewController {
    // Use default text style
    aTextView.font = self.defaultFont;
    aTextView.textColor = self.defaultTextColor;
  }

  - (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController replaceDefaultStyleWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    self.defaultFont = font;
    self.defaultTextColor = textColor;
  }

  - (void)textStylePickerViewControllerIsDone:(CMTextStylePickerViewController *)textStylePickerViewController {
    [self dismissModalViewControllerAnimated:YES];
  }


See the demo application, CMTextStylePickerDemo, for more examples of use.
CMTextStylePickerDemo is a universal app and demonstrates the use of
CMTextStylePicker on both iPhone and iPad user interfaces.


License
-------

CMTextStylePicker is released under the MIT license.  See LICENSE for details.

CMTextStylePicker is copyright (c) Chris Miles 2010.
