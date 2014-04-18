# Reference jQuery
$ = jQuery

# Adds plugin object to jQuery
$.fn.extend
  # Change pluginName to your plugin's name.
  typetype: (text) ->
    # temporary hack, just work on the first
    textarea = @.first() #TODO figure out whether it's an input or a textarea

    return $.Deferred( (deferred) ->

      updateText = (textarea, text, limit, deferred) ->
        textarea.text(text.substr(0,limit))
        if limit < text.length
          setTimeout(() ->
            updateText(textarea, text, limit+1, deferred)
          ,100)
        else
          deferred.resolve()

      updateText(textarea, text, 1, deferred)

    )
