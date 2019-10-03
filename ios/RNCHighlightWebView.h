//
//  NoSelectWebView.h
//  RNCWebView
//
//  Created by Javier on 9/26/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RNCHighlightWebViewDelegate

-(void)htmlContentChanged:(NSString*)newHTML;

@end

@interface RNCHighlightWebView : WKWebView

@property (weak, nonatomic) id<RNCHighlightWebViewDelegate> delegate;
@property (nonatomic, assign) BOOL highlightEnabled;

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration highlightEnabled:(BOOL)highlight;

@end

NS_ASSUME_NONNULL_END
