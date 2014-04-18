# Reference jQuery
$ = jQuery

# Adds plugin object to jQuery
$.fn.extend
  # Change pluginName to your plugin's name.
  typetype: (text) ->
    return @each (i, item) ->
      $(@).html(text)
