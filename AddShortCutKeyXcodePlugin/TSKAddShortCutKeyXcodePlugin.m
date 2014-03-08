//
//  TSKAddShortCutKeyXcodePlugin.m
//  TSKAddShortCutKeyXcodePlugin
//
//  Created by 千葉 俊輝 on 2014/03/08.
//    Copyright (c) 2014年 Toshiki Chiba. All rights reserved.
//

#import "TSKAddShortCutKeyXcodePlugin.h"

static TSKAddShortCutKeyXcodePlugin *sharedPlugin;

@interface TSKAddShortCutKeyXcodePlugin()

@property (nonatomic, strong) NSBundle *bundle;
@end

@implementation TSKAddShortCutKeyXcodePlugin

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        self.bundle = plugin;
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"File"];
        if (menuItem) {
            int count = 0;
            for(NSMenuItem *smenu in [[menuItem submenu] itemArray]){
                if([smenu.title isEqualToString:@"Show in Finder"]){
                    
                    NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:smenu.title action:smenu.action keyEquivalent:@"0"];
                    actionMenuItem.keyEquivalentModifierMask = NSCommandKeyMask | NSShiftKeyMask;
                    [actionMenuItem setTarget:smenu.target];
                    [[menuItem submenu] removeItem:smenu];
                    [[menuItem submenu] insertItem:actionMenuItem atIndex:count];
                }
                count++;
            }
        }

        
        NSMenuItem *sourceMenuItem = [[NSApp mainMenu] itemWithTitle:@"Source Control"];
        if (sourceMenuItem) {
            int count = 0;
            for(NSMenuItem *smenu in [[sourceMenuItem submenu] itemArray]){
                if([smenu.title isEqualToString:@"Push…"]){
                    NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:smenu.title action:smenu.action keyEquivalent:@"7"];
                    actionMenuItem.keyEquivalentModifierMask = NSCommandKeyMask | NSShiftKeyMask;
                    [actionMenuItem setTarget:smenu.target];
                    [[sourceMenuItem submenu] removeItem:smenu];
                    [[sourceMenuItem submenu] insertItem:actionMenuItem atIndex:count];
                }
                if([smenu.title isEqualToString:@"History…"]){
                    NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:smenu.title action:smenu.action keyEquivalent:@"6"];
                    actionMenuItem.keyEquivalentModifierMask = NSCommandKeyMask | NSShiftKeyMask;
                    [actionMenuItem setTarget:smenu.target];
                    [[sourceMenuItem submenu] removeItem:smenu];
                    [[sourceMenuItem submenu] insertItem:actionMenuItem atIndex:count];
                }
                count++;
            }
        }
        
        NSMenuItem *productMenuItem = [[NSApp mainMenu] itemWithTitle:@"Product"];
        if (productMenuItem) {
            int count = 0;
            for(NSMenuItem *smenu in [[productMenuItem submenu] itemArray]){
                if([smenu.title isEqualToString:@"Archive"]){
                    NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:smenu.title action:smenu.action keyEquivalent:@"="];
                    actionMenuItem.keyEquivalentModifierMask = NSCommandKeyMask | NSShiftKeyMask;
                    [actionMenuItem setTarget:smenu.target];
                    [[productMenuItem submenu] addItem:actionMenuItem];
                }
                count++;
            }
        }


    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
