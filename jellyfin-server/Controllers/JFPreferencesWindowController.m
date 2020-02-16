//
//  JFPreferencesWindowController.m
//  Originally PreferencesWindowController.m from syncthing-macos
//
//  Created by Jerry Jacobs on 12/06/16.
//  Copyright © 2016 Jerry Jacobs. All rights reserved.
//

#import "JFPreferencesWindowController.h"
#import "JFPreferencesGeneralViewController.h"
#import "JFPreferencesAdvancedViewController.h"

@interface JFPreferencesWindowController ()

@end

@implementation JFPreferencesWindowController

enum
{
    kGeneralView = 0,
    kAdvancedView
};

- (id) init {
    return [super initWithWindowNibName:NSStringFromClass(self.class)];
}

- (void) awakeFromNib {
    [self setViewFromId:kGeneralView];
}

- (void) windowDidLoad {
    [super windowDidLoad];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void) setViewFromId:(NSInteger) tag {
    if ([_currentViewController view] != nil)
        [[_currentViewController view] removeFromSuperview];
    
    switch (tag) {
        case kGeneralView:
            if (self.generalView == nil)
                _generalView = [[JFPreferencesGeneralViewController alloc] init];
            _currentViewController = self.generalView;
            break;
        case kAdvancedView:
            if (self.advancedView == nil)
                _advancedView = [[JFPreferencesAdvancedViewController alloc] init];
            _currentViewController = self.advancedView;
        default:
            break;
    }
    
    [[self window] setContentView:[_currentViewController view]];
    
    // set the view controller's represented object to the number of subviews in that controller
    // (our NSTextField's value binding will reflect this value)
    [self.currentViewController setRepresentedObject:[NSNumber numberWithUnsignedInteger:[[_currentViewController.view subviews] count]]];

    // this will trigger the NSTextField's value binding to change
    [self didChangeValueForKey:@"viewController"];
}

- (IBAction) toolbarButtonClicked:(id)sender {
    NSToolbarItem *button = sender;
    [self setViewFromId:[button tag]];
}
@end
