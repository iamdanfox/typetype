# Reference jQuery
$ = jQuery

# Adds plugin object to jQuery
$.fn.extend
  # Change pluginName to your plugin's name.
  typetype: (text) ->
    # temporary hack, just work on the first
    textarea = @.first()

    return $.Deferred( (deferred) =>
      setTimeout(() =>
        textarea.html(text)
        deferred.resolve()
      , 1000)
    )
