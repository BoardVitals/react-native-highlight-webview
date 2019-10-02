# React Native WebView - a Modern, Cross-Platform WebView for React Native

**React Native WebView** is a modern, well-supported, and cross-platform WebView for React Native. It is intended to be a replacement for the built-in WebView (which will be [removed from core](https://github.com/react-native-community/discussions-and-proposals/pull/3)).

This fork adds highlight functionality to React Native Webview

## Platforms Supported

- [x] iOS (both UIWebView and WKWebView)
- [x] Android
- [ ] Windows 10 (coming soon)

_Note: React Native WebView is not currently supported by Expo unless you "eject"._

## Versioning

If you need the exact same WebView as the one from react-native, please use version **2.0.0**. Future versions will follow [semantic versioning](https://semver.org/).

## Getting Started

```
$ npm install --save BoardVitals/react-native-highlight-webview#boardvitals_highlight_pre_upgrade
$ react-native link react-native-webview
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
              onHtmlChanged={event => Alert.alert('HTML Changed:', event.nativeEvent.data)}
              style={{ flex: 0, width: 400, height: 200 }}
              originWhitelist={'*'}
              javaScriptEnabled
              source={{html: question.get('safe_name')}}
            />
    );
  }
}
```
## NOTE: If onHtmlChanged prop is passed to the component, highlight functionality is enabled and rangy library is injected into the library. Otherwise, the webview behaves likes the standard webview from the forked project. rangy.js file has to be located in the root iOS folder and added to the project target for iOS and app/src/main/assets folder for android


For more, read the [API Reference](./docs/Reference.md) and [Guide](./docs/Guide.md). If you're interested in contributing, check out the [Contributing Guide](./docs/Contributing.md).

## Migrate from React Native core WebView to React Native WebView

Simply install React Native WebView and then use it in place of the core WebView. Their APIs are currently identical, except that this package defaults `useWebKit={true}` unlike the built-in WebView.




## License

MIT
