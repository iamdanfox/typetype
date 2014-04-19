($ = jQuery).fn.extend
  typetype: (txt, options) ->

    settings = $.extend(
      keypress: () -> # function :: (i) -> {}
      ms:100 # typing interval
      e:0.04 # error probability
    , options)

    interval = (i) -> Math.random() * settings.ms * (
      if txt[i-1] is txt[i] then 1.6
      else if txt[i-1] is '.' then 12
      else if txt[i-1] is '!' then 12
      else if txt[i-1] is '\n' then 12
      else if txt[i-1] is ',' then 8
      else if txt[i-1] is ';' then 8
      else if txt[i-1] is ' ' then 3
      else 2
    )

    return @each ->
      elem = @
      $(elem).queue -> # this function goes into the 'fx' queue.

        # ensure we 'type' into the right thing
        attr = if elem.tagName is 'input'.toUpperCase() or elem.tagName is
            'textarea'.toUpperCase()
          'value'
        else
          'innerHTML'

        append = (str, cont) ->
          if str # > 0
            elem[attr] += str[0]
            setTimeout (-> append str.slice(1), cont), settings.ms
          else
            cont()
          return

        backsp = (num, cont) ->
          if num # > 0
            elem[attr] = elem[attr].slice 0, -1 # inlined delchar function
            setTimeout (-> backsp num-1, cont), settings.ms
          else
            cont()
          return

        (typeTo = (i) ->
          if len = txt.length >= i
            afterErr = -> setTimeout (-> typeTo i), interval(i)

            r = Math.random()
            # omit character, recover after 4 more chars
            if settings.e * 0.3>r and txt[i-1] isnt txt[i] and i+4<len
              append txt.slice(i,i+4), -> backsp 4, afterErr

            # omit character, recover immediately
            else if settings.e * 0.5>r and txt[i-1] isnt txt[i] and i<len
              append txt[i], -> backsp 1, afterErr

            # swap two characters
            else if settings.e * 0.8>r and txt[i-1] isnt txt[i] and i<len
              append txt[i]+txt[i-1], -> backsp 2, afterErr

            # hold shift too long
            else if settings.e * 1.0>r and i>1 and txt[i-2] is
                txt[i-2].toUpperCase() and i+4<len
              append txt[i-1].toUpperCase()+txt.slice(i,i+4), ->
                backsp 5, afterErr

            # just insert the correct character!
            else
              elem[attr] += txt[i-1]
              settings.keypress.call elem, i
              setTimeout (-> typeTo i+1), interval(i)
          else
            $(elem).dequeue()
          return
        )(1)
