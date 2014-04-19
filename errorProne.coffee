
$ = jQuery
$.fn.extend

  # text: string to insert into every matched element
  # callback: function() to be called when text has been inserted into each elem
  # keypress: function(index) called after every (correct) keypress
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
        if tag = elem.tagName.toLowerCase() is 'input' or tag is 'textarea'
          typeChar = (c) -> elem.value += c
          delChar = () ->
            elem.value = elem.value.substr(0,elem.value.length-1)
        else
          typeChar = (c) -> elem.innerHTML += c
          delChar = () ->
            elem.innerHTML = elem.innerHTML.substr(0,elem.innerHTML.length-1)

        append = (str, continuation) ->
          if str.length > 0
            typeChar(str[0])
            setTimeout (()->append(str.substr(1), continuation)), charDelay
          else
            continuation()

        backspace = (num, continuation) ->
          if num > 0
            delChar()
            setTimeout (()->backspace(num-1, continuation)), charDelay
          else
            continuation()

        deferred = $.Deferred()

        typeTo = (index) ->
          if index < text.length
            r = Math.random()
            afterErr = () -> setTimeout (()-> typeTo(index)), interval(index)
            switch
              when r<errorProb*0.1 then append "XYZ", () -> backspace(3, afterErr)
              when r<errorProb*0.4 then append "XY", () -> backspace(2, afterErr)
              when r<errorProb then append "X", () -> backspace(1, afterErr)
              else
                typeChar(text[index-1])
                keypress?.call(elem, index)
                setTimeout (()-> typeTo(index+1)), interval(index)
          else
            deferred.resolve()
          return

        # start it all off immediately!
        typeTo(1)

        return deferred.done(() -> callback?.call(elem))

    # combined promise of all of them
    return $.when(deferreds...) # ie $.when(d1, d2)   NOT   $.when([d1,d2])
