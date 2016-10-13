---
title: "UI design for failure"
date: 2016-10-12
tags: [UI, networks]
layout: post
---

On mobile, in code as well as UI design we design for the happy path. All requests succeed

The idea that background requests are made, and the UI might be in an indeterminate state often isn't considered. Instead its tested, the solution is often to block the UI until a request completes.

However there are better ways of designing both the code and UI and if the different modes are understood up-front hopefully the result will be a more responsive, less-confusing UI.

Kris Jenkins [proposes](http://blog.jenkster.com/2016/06/how-elm-slays-a-ui-antipattern.html) that the model behind the UI can be multiple states, which should be reflected in the model:

```elm
type RemoteData e a
    = NotAsked
    | Loading
    | Failure e
    | Success a
```
