//
//  NoSelectWebView.m
//  RNCWebView
//
//  Created by Javier on 9/26/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "RNCHighlightWebView.h"

@implementation RNCHighlightWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration highlightEnabled:(BOOL)highlight {
    if (highlight){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMenuWillShowNotification:)
                                                     name:UIMenuControllerWillShowMenuNotification
                                                   object:nil];
        [[NSClassFromString(@"UICalloutBarButton") appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[NSClassFromString(@"UICalloutBarButton") appearance] setBackgroundColor:[UIColor colorWithRed:22.0f/255.0f green:110.0f/255.0f blue:213.0f/255.0f alpha:1.0f]];
        UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Highlight"
                                                          action:@selector(highlight:)];
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:menuItem,nil]];
        
    }
    return [super initWithFrame:frame configuration:configuration];
}

- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    UIMenuController *menu = [notification object];
    CGRect frame = CGRectMake(menu.menuFrame.origin.x, menu.menuFrame.origin.y - 140, menu.menuFrame.size.width, menu.menuFrame.size.height);
    [menu setMenuVisible:NO animated:YES];
    [self evaluateJavaScript:@"document.queryCommandValue('backcolor')" completionHandler:^(id _Nullable currentColor, NSError * _Nullable error) {
        if ([currentColor isEqualToString:@"rgba(0, 0, 0, 0)"]) { // Not Highlighted => Adding highlight
            UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Highlight"
                                                              action:@selector(highlight:)];
            [menu setMenuItems:[NSArray arrayWithObjects:menuItem,nil]];
            [menu setTargetRect:frame inView:self];
            [menu setArrowDirection:UIMenuControllerArrowDefault];
            [menu setMenuVisible:YES animated:YES];
        }
        else{ // Highlighted => Removing highlight
            UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"Remove Highlight"
                                                               action:@selector(removeHighlight:)];
            [menu setMenuItems:[NSArray arrayWithObjects:menuItem2,nil]];
            [menu setTargetRect:frame inView:self];
            [menu setArrowDirection:UIMenuControllerArrowDefault];
            [menu setMenuVisible:YES animated:YES];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMenuWillShowNotification:)
                                                     name:UIMenuControllerWillShowMenuNotification
                                                   object:nil];
    }];
    
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.clipboardDisabled){
        return NO;
    } else if (self.highlightEnabled){
        if (action == @selector(highlight:) || action == @selector(removeHighlight:)) {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void) highlight:(id)sender {
    [self evaluateJavaScript:@"highlightSelectedText()" completionHandler:^(id _Nullable newHtml, NSError * _Nullable error) {
        [self evaluateJavaScript:@"getHighlights()" completionHandler:^(id _Nullable highlights, NSError * _Nullable error) {
            if (self.delegate != nil) {
                [self.delegate htmlContentChanged:newHtml ranges:highlights];
            }
        }];
    }];
}

- (void) removeHighlight:(id)sender {
    [self evaluateJavaScript:@"removeHighlightFromSelectedText()" completionHandler:^(id _Nullable newHtml, NSError * _Nullable error) {
        [self evaluateJavaScript:@"getHighlights()" completionHandler:^(id _Nullable highlights, NSError * _Nullable error) {
            if (self.delegate != nil) {
                [self.delegate htmlContentChanged:newHtml ranges:highlights];
            }
        }];
    }];
}


@end
