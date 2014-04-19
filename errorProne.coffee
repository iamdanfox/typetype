
$ = jQuery
$.fn.extend

  # text: string to insert into every matched element
  # callback: function() to be called when text has been inserted into each elem
  # keypress: function(index) called after every keypress
  typetype: (text, callback, keypress) ->
    charDelay = 100
    errorProb = 0.05

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

    recoverMistakeInterval = 2*charDelay

    deferreds = for elem in @
      do (elem) ->
        # ensure we 'type' into the right thing
        # TODO: simulate events... keydown, keypress, textInput, keyup (security?)
        tag = elem.tagName.toLowerCase()
        if tag is 'input' or tag is 'textarea'
          typeChar = (c) -> elem.value += c
          delChar = () ->
            elem.value = elem.value.substr(0,elem.value.length-1)
        else
          typeChar = (c) -> elem.innerHTML += c
          backspace = () ->
            elem.innerHTML = elem.innerHTML.substr(0,elem.innerHTML.length-1)

        makeMistake = (index) ->
          # TODO.. swap pairs of characters, mistype one
          appendString "XYZ", () -> backspace(3, () -> continueTo index+1) # backspace will then continue

        appendString = (toInsert, continuation) ->
          if toInsert.length > 0
            typeChar(toInsert[0])
            setTimeout () ->
              appendString(toInsert.substr(1), continuation)
            , charDelay
          else
            continuation()

        backspace = (num, continuation) ->
          if num > 0
            delChar()
            setTimeout (()->backspace(num-1, continuation)), charDelay
          else
            continuation()

        deferred = $.Deferred()

        continueTo = (index) ->
          # append one char
          typeChar(text[index-1])
          keypress?.call(elem, index)

          # timeout recursion
          if index < text.length
            if Math.random() < errorProb
              # TODO. different timing logic for mistakes?
              setTimeout (() -> makeMistake(index)), interval(index)
            else
              setTimeout (()-> continueTo(index+1)), interval(index)
          else
            deferred.resolve()

          return

        # start it all off immediately!
        continueTo(1)

        return deferred.done(() -> callback?.call(elem))

    # combined promise of all of them
    return $.when(deferreds...) # ie $.when(d1, d2)   NOT   $.when([d1,d2])
