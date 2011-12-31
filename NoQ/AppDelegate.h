//
//  AppDelegate.h
//  NoQ
//
//  Created by Jason Chutko on 11-12-29.
//  Copyright (c) 2011 Jason Chutko. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    IBOutlet NSMenuItem *stateItem;
    IBOutlet NSPanel *hudWindow;
}

- (IBAction)quitApp:(id)sender;
- (IBAction)changeState:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (retain) IBOutlet NSMenuItem *stateItem;
@property (retain) IBOutlet NSPanel *hudWindow;

@end