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
        [[NSClassFromString(@"UICalloutBarButton") appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[NSClassFromString(@"UICalloutBarButton") appearance] setBackgroundColor:[UIColor colorWithRed:22.0f/255.0f green:110.0f/255.0f blue:213.0f/255.0f alpha:1.0f]];
        
        UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"ADD/REMOVE HIGHLIGHT"
                                                          action:@selector(highlight:)];
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:menuItem]];
        [UIMenuController sharedMenuController].menuVisible = YES;
    }
    return [super initWithFrame:frame configuration:configuration];
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (self.highlightEnabled){
        //TODO: Show HIGHLIGHT / REMOVE HIGHLIGHT
        if (action == @selector(highlight:)) {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void) highlight:(id)sender  {
    [self evaluateJavaScript:@"document.queryCommandValue('backcolor')" completionHandler:^(id _Nullable currentColor, NSError * _Nullable error) {
        if ([currentColor isEqualToString:@"rgba(0, 0, 0, 0)"]) { // Not Highlighted => Adding highlight
            [self evaluateJavaScript:@"highlightSelectedText()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                if (self.delegate != nil) {
                    [self.delegate htmlContentChanged:result];
                }
            }];
            
        } else{ // Highlighted => Removing highlight
            [self evaluateJavaScript:@"removeHighlightFromSelectedText()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                if (self.delegate != nil) {
                    [self.delegate htmlContentChanged:result];
                }
            }];
        }
    }];
}


@end
