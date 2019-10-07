# React Native WebView - a Modern, Cross-Platform WebView for React Native

**React Native WebView** is a modern, well-supported, and cross-platform WebView for React Native. It is intended to be a replacement for the built-in WebView (which will be [removed from core](https://github.com/react-native-community/discussions-and-proposals/pull/3)).

This fork adds highlight functionality to React Native Webview

## Platforms Supported

- [x] iOS (WKWebView)
- [x] Android
- [ ] Windows 10 (coming soon)



## Versioning

If you need the exact same WebView as the one from react-native, please use version **2.0.0**. Future versions will follow [semantic versioning](https://semver.org/).

## Getting Started

```
$ npm install --save BoardVitals/react-native-highlight-webview#boardvitals_highlight_post_upgrade

//In RN 0.60 and above the library will be autolinked, no need to do step below
$ react-native link react-native-webview

$ cd ios && pod install
```

Read our [Getting Started Guide](./docs/Getting-Started.md) for more.

## Usage

Import the `WebView` component from `react-native-webview` and use it like so:


```jsx
import React, { Component } from "react";
import { StyleSheet, Text, View } from "react-native";
import { WebView } from "react-native-webview";

// ...
class MyWebComponent extends Component {
  render() {
    return (
      <WebView
              onHtmlChanged={event => this.props.highlightCreateOrUpdate(quizId, questionId, event.nativeEvent.data, event.nativeEvent.ranges)}
               style={{ flex: 0, width: 400, height: 200 }}
               source={{html: highlightFound ? highlightFound.stem : question.get('safe_name')}}
               injectedJavaScript={highlightFound ? `setHighlights("${highlightFound.ranges}")` : null}
               originWhitelist={'*'}
               javaScriptEnabled
            />
    );
  }
}
```

## For ease of use we have created a component to wrap this webview called HighlightWebView. This component will pass the html string as a source and the previous highlight ranges found as a prop so rangy library is able to load them on top of the original stem. onHtmlChanged callback includes the new stem and the new highlight ranges. Since we only need the ranges for rangy to create the highlights, we don't store the new stems in the server, only the new ranges. At some point we can remove the stem field from the highlights reducer. This component also takes care of automatically detecting the height the html document will need and adding styles to the stem that can be modified according to the specs.

Example of usage:

```jsx
           <HighlightWebView
              onHtmlChanged={event => this.props.highlightCreateOrUpdate(quizId, questionId, '<p></p>', event.nativeEvent.ranges)}
              source={{html: question.get('safe_name')}}
              injectedRanges={highlightFound ? `setHighlights("${highlightFound.ranges}")` : undefined}
              autoHeight
              defaultHeight={50}
            />
```

## License

MIT
