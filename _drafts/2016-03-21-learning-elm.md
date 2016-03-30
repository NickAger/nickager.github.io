Some elm links:

* [Elm - examples](http://elm-lang.org/examples)
* [Elm - Model the problem](http://elm-lang.org/guide/model-the-problem)
* [Convert Html to Elm](http://mbylstra.github.io/html-to-elm/)
* [Redit Elm](https://www.reddit.com/r/elm/)
* [Elm Check ala Quick Check](https://github.com/TheSeamau5/elm-check)
* [Google Groups Elm discuss](https://groups.google.com/forum/#!forum/elm-discuss)
* [Elm playlist - list to vidoes, podcasts featuring Elm](http://crossingtheruby.com/2015/11/10/elm-playlist.html)
* [Richard Feldman Github repositories](https://github.com/rtfeldman?tab=repositories)
* [Guy learning Elm - crossingtheruby.com](http://crossingtheruby.com)
* [Next steps from pragmatic studio course](https://online.pragmaticstudio.com/courses/elm-signals/next_steps)
* [Typed up CRUD SPA with Haskell and Elm](http://rundis.github.io/blog/2015/haskell_elm_spa_part1.html) "A single page web application with crud features"
* [Elm slack channel](https://elmlang.slack.com/messages/general/)
* [Typed up CRUD SPA with Haskell and Elm - Part 1: Spike time](http://rundis.github.io/blog/2015/haskell_elm_spa_part1.html) - Guy learning FP with Haskell and Elm
* [The code associated with the above blog](https://github.com/rundis/albums)
* [Looking up US zip codes](http://elm-lang.org/examples/zip-codes) eg 201166 from http://elm-lang.org/examples/zip-codes
* [Querying flikr](http://elm-lang.org/examples/flickr) from http://elm-lang.org/examples/flickr
* [Reactivity - tasks etc](http://elm-lang.org/guide/reactivity) from http://elm-lang.org/guide/reactivity
* [Elm Tutorial](http://www.elm-tutorial.org) covers routing
* [No Red Ink Elm style guide](https://github.com/NoRedInk/elm-rails/wiki/NoRedInk's-Elm-Style-Guide)
* [Elm by Example](http://elm-by-example.org)  - includes a snake game
* [Planet Elm](http://planet.elm-lang.org) news aggregator.
* [FancyStartApp](https://github.com/vilterp/fancy-start-app/blob/master/src/FancyStartApp.elm) - [pull request discussion](https://github.com/evancz/start-app/pull/11) background [discussion](https://groups.google.com/forum/#!topic/elm-discuss/Ro4C6moKD0k)
* [Share Elm](http://www.share-elm.com)

---

## Elm and local state
* [Composing Elm Views](https://groups.google.com/forum/#!topic/elm-discuss/LW4plT8O18I) - old post from 2014 refers to LocalChannel
* [Is is possible to create self contained components with local signals](https://www.reddit.com/r/elm/comments/3pfs39/is_it_possible_to_create_self_contained/) "You might be able to just take an existing component, run it through startapp, and map over the resulting Signal Html to put it into a larger Html. That'll decouple things in the way you're looking for I think." - "The elm-html package let's you build up Html, and put it as a child node of another Html tag. So if you run startapp, get your Signal Html representation of the component, then you can Signal.mapa function over it of type Html -> Html, that takes the Html of the component and wraps it in some other Html. Done :)"
* [Best way to handle small, short-lived, "local" state in UI components, without mixing view logic with model logic?](https://www.reddit.com/r/elm/comments/40006k/best_way_to_handle_small_shortlived_local_state/)
* [Making Elm faster and friendlier in 0.16 ](https://news.ycombinator.com/item?id=10595131) - theres a discussion about local component state
* [Updating input fields without losing the cursor position](https://groups.google.com/forum/#!topic/elm-discuss/I2JleY8bD7c)
* [Example of local and global state](https://gist.github.com/brodo/6495e486648d235e10a5) which is from [https://github.com/brodo/mushroomcup](https://github.com/brodo/mushroomcup)
* [Simple Made Easy. Where Elm going?](https://groups.google.com/forum/#!topic/elm-dev/gfoiSFLc19s) - discussion of local and global state

