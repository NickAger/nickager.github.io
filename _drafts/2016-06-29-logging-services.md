---
title: "Logging services"
date: 2016-06-29
tags: [Swift, logging]
layout: post
---
I want to be able to log errors into a service

Previously I've written custom server-side code wrapping up CocoaLumberjack which remotely allowed different logging to be switched on at a class level.

However I felt there should be some 3rd party service that at least would provide logging as a service. There does appear to be a bit of a gap.

### Logging libraries
There are plenty of [logging libraries](https://github.com/matteocrippa/awesome-swift#logging) however none of these appear to complement a backend service. Also https://github.com/Nike-Inc/Willow

### Crash reporting tools
The granddaddy of these tools is Crashlytics  It does offer [enhanced crash reports](https://docs.fabric.io/apple/crashlytics/enhanced-reports.html) and [logging errors](https://docs.fabric.io/apple/crashlytics/logged-errors.html).

For example:

```swift
// errors
Crashlytics.sharedInstance().recordError(error)

// logging values
Crashlytics.sharedInstance().setIntValue(42, forKey: "MeaningOfLife")
Crashlytics.sharedInstance().setObjectValue("Test value", forKey: "last_UI_action"

CLSLogv("Log awesomeness %d %d %@", getVaList([1, 2, "three"]))
```

Out of all the above `recordError` and `CLSLogv` look the most useful, but the Swift API to `CLSLogv` looks unnecessary ugly - why not use [Swift's String interpolation](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/StringsAndCharacters.html)

It also comes with the warning

> CLSLog is meant for logging information important to solving crashes. It should not be used to track in-app events.
> Crashlytics ensures that all log entries are recorded, even if the very next line of code crashes. This means that logging must incur some IO. Be careful when logging in performance-critical areas.

Which implies to me that you only see the log entry if your app crashes.


## Analytics tools

### Fabrics Answers events

To quote from the [docs](https://docs.fabric.io/apple/answers/answers-events.html):

> Answers Events gives you the ability to track the specific actions and events in your app that matter most. You can now see how users are behaving in your app and surfacing that critical information in real-time.

It looks quite good for analytics, but doesn't seem to have a log error, log info feature. Everything appears to be an [info](https://docs.fabric.io/apple/answers/answers-events.html#custom-attributes):

```swift
Answers.logCustomEventWithName("My First Custom Event",
                      customAttributes: [
                          "Custom String": "foo",
                          "Custom Number": 35])
```


## Mixpanel
https://mixpanel.com/engagement/

## NewRelic
https://newrelic.com/ios-app-optimization

### On-line logging services
http://riemann.io
