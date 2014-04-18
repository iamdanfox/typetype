# Reference jQuery
$ = jQuery

# Adds plugin object to jQuery
$.fn.extend
  # Change pluginName to your plugin's name.
  typetype: (text) ->

    charDelay = 100

    interval = (limit) -> # avg interval = 100
      lastchar = text[limit-1]
      nextchar = text[limit]

      # pause after punctuation
      if lastchar in ['.', '!'] then return 9*charDelay
      if lastchar in [',', ';'] then return 4*charDelay

      # pause for spaces
      if lastchar is ' ' then return 2*charDelay

      # pause at at end of enters.
      if lastchar is '\n' and nextchar isnt '\n' then return 5*charDelay

      return 2*charDelay*Math.random()

    deferreds = for t in @
      do (t) ->
        $.Deferred( (deferred) ->

          # do all the typing for the single textarea, `t`
          updateChar = (limit) ->
            # append one char
            $(t).html(text.substr(0,limit))

            # timeout recurse
            if limit < text.length
              setTimeout () ->
                updateChar(limit+1)
              , interval(limit)  # interval depends on position in string
            else
              deferred.resolve()

          # start it all off immediately!
          updateChar(1)
        )

    # combined promise of all of them
    return $.when(deferreds...) # ie $.when(d1, d2)   NOT   $.when([d1,d2])
