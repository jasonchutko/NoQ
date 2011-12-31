//
//  AppDelegate.m
//  NoQ
//
//  Created by Jason Chutko on 11-12-29.
//  Copyright (c) 2011 Jason Chutko. All rights reserved.
//

/* Credits
 http://cocoatutorial.grapewave.com/2010/01/creating-a-status-bar-application/#comments
 https://github.com/davedelong/DDHotKey
 */

#import "AppDelegate.h"
#import "DDHotKeyCenter.h"
#include <ApplicationServices/ApplicationServices.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize stateItem, hudWindow;

void PostKeyWithModifiers(CGKeyCode key, CGEventFlags modifiers);

bool enabled = true;
double lastTime = 0;
NSTimer *timer;

- (void)onTick:(id)sender
{
    [hudWindow orderOut:nil];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [hudWindow setFloatingPanel:YES];
    [hudWindow setAlphaValue:0.95];    
}

void PostKeyWithModifiers(CGKeyCode key, CGEventFlags modifiers)
{
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    
    CGEventRef keyDown = CGEventCreateKeyboardEvent(source, key, TRUE);
    CGEventSetFlags(keyDown, modifiers);
    CGEventRef keyUp = CGEventCreateKeyboardEvent(source, key, FALSE);
    
    CGEventPost(kCGAnnotatedSessionEventTap, keyDown);
    CGEventPost(kCGAnnotatedSessionEventTap, keyUp);
    
    CFRelease(keyUp);
    CFRelease(keyDown);
    CFRelease(source);  
}

- (void)registerHotkey
{
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	if (![c registerHotKeyWithKeyCode:12 modifierFlags:NSCommandKeyMask target:self action:@selector(hotkeyWithEvent:) object:nil]) {
		NSLog(@"Unable to register hotkey for example 1");
	} else {
		NSLog(@"Registered hotkey for example 1");
	} 
}

- (void)unregisterHotkey
{
    DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	[c unregisterHotKeyWithKeyCode:12 modifierFlags:NSCommandKeyMask];
	NSLog(@"Unregistered hotkey for example 1"); 
}

- (IBAction)changeState:(id)sender
{
    if (enabled) {
        [self unregisterHotkey];
        [stateItem setTitle:@"Enable"];
    } else {
        [self registerHotkey];
        [stateItem setTitle:@"Disable"];
    }
    
    enabled = !enabled;
}

- (void)hotkeyWithEvent:(NSEvent *)hkEvent 
{
    if (lastTime == 0 || [hkEvent timestamp] - lastTime > 2) {
        [hudWindow makeKeyAndOrderFront:nil];
        timer = [NSTimer scheduledTimerWithTimeInterval: 10.0
                                                 target: self
                                               selector:@selector(onTick:)
                                               userInfo: nil repeats:NO];
        lastTime = [hkEvent timestamp];
    } else {
        PostKeyWithModifiers(0x0C, NSCommandKeyMask);
        [hudWindow orderOut:nil];
        [timer invalidate];
        lastTime = 0;
    }
}

- (IBAction)quitApp:(id)sender 
{ 
    [self unregisterHotkey];
    [[NSApplication sharedApplication] terminate:nil];
} 

- (void)awakeFromNib
{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"|⌘Q|"];
    [statusItem setHighlightMode:YES];
    [self registerHotkey];
}

@end