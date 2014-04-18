# Reference jQuery
$ = jQuery

# Adds plugin object to jQuery
$.fn.extend
  # Change pluginName to your plugin's name.
  typetype: (text) ->

    interval = () -> # avg interval = 100
      200*Math.random()

    deferreds = for t in @
      do (t) ->
        $.Deferred( (deferred) ->

          # do all the typing for the single `t`
          updateChar = (limit) ->
            # append one char
            $(t).html(text.substr(0,limit))

            # timeout recurse
            if limit < text.length
              setTimeout(() ->
                updateChar(limit+1)
              , interval())
            else
              deferred.resolve()

          # start it all off immediately!
          updateChar(1)
        )

    # combined promise of all of them
    return $.when(deferreds...) # ie $.when(d1, d2)   NOT   $.when([d1,d2])
