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
        
    }
    return [super initWithFrame:frame configuration:configuration];
}

- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    UIMenuController *menu = [notification object];
    [menu setMenuVisible:NO animated:NO];
    [self evaluateJavaScript:@"document.queryCommandValue('backcolor')" completionHandler:^(id _Nullable currentColor, NSError * _Nullable error) {
        if ([currentColor isEqualToString:@"rgba(0, 0, 0, 0)"]) { // Not Highlighted => Adding highlight
            UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Highlight"
                                                              action:@selector(highlight:)];
            [menu setMenuItems:[NSArray arrayWithObjects:menuItem,nil]];
            [menu setMenuVisible:YES animated:NO];
        }
        else{
            UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"Remove Highlight"
                                                               action:@selector(removeHighlight:)];
            [menu setMenuItems:[NSArray arrayWithObjects:menuItem2,nil]];
            [menu setMenuVisible:YES animated:NO];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMenuWillShowNotification:)
                                                     name:UIMenuControllerWillShowMenuNotification
                                                   object:nil];
    }];
    
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (self.highlightEnabled){
        //TODO: Show HIGHLIGHT / REMOVE HIGHLIGHT
        if (action == @selector(selectAll:) || action == @selector(highlight:) || action == @selector(removeHighlight:)) {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void) highlight:(id)sender  {
    [self evaluateJavaScript:@"highlightSelectedText()" completionHandler:^(id _Nullable newHtml, NSError * _Nullable error) {
         [self evaluateJavaScript:@"getHighlights()" completionHandler:^(id _Nullable highlights, NSError * _Nullable error) {
            if (self.delegate != nil) {
                [self.delegate htmlContentChanged:newHtml ranges:highlights];
            }
         }];
    }];
}

- (void) removeHighlight:(id)sender  {
    [self evaluateJavaScript:@"removeHighlightFromSelectedText()" completionHandler:^(id _Nullable newHtml, NSError * _Nullable error) {
        [self evaluateJavaScript:@"getHighlights()" completionHandler:^(id _Nullable highlights, NSError * _Nullable error) {
            if (self.delegate != nil) {
                [self.delegate htmlContentChanged:newHtml ranges:highlights];
            }
        }];
    }];
}


@end
