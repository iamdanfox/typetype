
$ = jQuery
$.fn.extend

  # text: string to insert into every matched element
  # callback: function() to be called when text has been inserted into each elem
  # keypress: function(index) called after every keypress
  typetype: (text, callback, keypress) ->
    charDelay = 100

    # function returns the delay before the next character
    interval = (index) ->
      lastchar = text[index-1]
      nextchar = text[index]
      return Math.random()*charDelay * switch lastchar
        # fast repeat keys
        when nextchar then 1.6
        # pause after punctuation
        when '.', '!' then 16
        when ',', ';' then 8
        # pause for spaces
        when ' ' then 3
        # pause at the end of lots of newlines
        when lastchar is '\n' and nextchar isnt '\n' then 10
        else 2

    deferreds = for elem in @
      do (elem) ->
        # ensure we 'type' into the right thing
        # TODO: simulate events... keydown, keypress, textInput, keyup (security?)
        tag = elem.tagName.toLowerCase()
        setText = if tag is 'input' or tag is 'textarea'
          (str) -> elem.value = str
        else
          (str) -> elem.innerHTML = str

        return $.Deferred( (deferred) ->
          continueTo = (index) ->
            # append one char
            setText(text.substr(0,index))
            keypress?.call(elem, index)

            # timeout recursion
            if index < text.length
              # TODO either proceed or make a mistake and queue a recovery
              setTimeout (()-> continueTo(index+1)), interval(index)
            else
              deferred.resolve()

          # start it all off immediately!
          continueTo(1)
        ).done(() -> callback?.call(elem))

    # combined promise of all of them
    return $.when(deferreds...) # ie $.when(d1, d2)   NOT   $.when([d1,d2])
