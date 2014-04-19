$ = jQuery
$.fn.extend
  # txt: string to insert into every matched element
  # callback: function() to be called when txt has been inserted into each elem
  # keypress: function(index) called after every (correct) keypress
  typetype: (txt, callback, keypress) ->
    charDelay = 100
    errorProb = 0.04

    # function returns the delay before the next character
    interval = (index) ->
      lastchar = txt[index-1]
      nextchar = txt[index]
      return Math.random()*charDelay * switch lastchar
        # fast repeat keys
        when nextchar then 1.6
        # pause after punctuation
        when '.', '!' then 12
        when ',', ';' then 8
        # pause for spaces
        when ' ' then 3
        # pause at the end of lots of newlines
        when '\n' then 12
        else 2

    deferreds = for elem in @
      do (elem) ->
        # ensure we 'type' into the right thing
        if tag = elem.tagName.toLowerCase() is 'input' or tag is 'textarea'
          typeChar = (c) -> elem.value += c
          delChar = () ->
            elem.value = elem.value.substr(0,elem.value.length-1)
        else
          typeChar = (c) -> elem.innerHTML += c
          delChar = () ->
            elem.innerHTML = elem.innerHTML.substr(0,elem.innerHTML.length-1)

        append = (str, cont) ->
          if str.length > 0
            typeChar(str[0])
            setTimeout (()->append(str.substr(1), cont)), charDelay
          else
            cont()

        backsp = (num, cont) ->
          if num > 0
            delChar()
            setTimeout (()->backsp(num-1, cont)), 1.5*charDelay
          else
            cont()

        deferred = $.Deferred()

        typeTo = (i) ->
          if i < txt.length
            r = Math.random()
            afterErr = () -> setTimeout (()-> typeTo(i)), interval(i)
            switch
              # omit character, recover after
              when r<0.3*errorProb and txt[i-1] isnt txt[i]
                append txt.substr(i,4), () -> backsp(4, afterErr)
              when r<0.5*errorProb and txt[i-1] isnt txt[i]
                append txt.substr(i,1), () -> backsp(1, afterErr)
              # swap two characters
              when r<0.8*errorProb and txt[i-1] isnt txt[i]
                append txt[i]+txt[i-1], () -> backsp(2, afterErr)
              # hold shift too long
              when r<1.0*errorProb and i>1 and txt[i-2].toUpperCase() is txt[i-2]
                append txt[i-1].toUpperCase()+txt[i], () -> backsp(2, afterErr)
              else
                typeChar(txt[i-1])
                keypress?.call(elem, i)
                setTimeout (()-> typeTo(i+1)), interval(i)
          else
            deferred.resolve()
          return

        typeTo(1)

        return deferred.done(() -> callback?.call(elem))

    # combined promise of all of them
    return $.when(deferreds...) # ie $.when(d1, d2)   NOT   $.when([d1,d2])
