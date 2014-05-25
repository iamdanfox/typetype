jQuery.fn.extend

  backspace: (num, options) ->
    settings = jQuery.extend(
      callback: () -> # `this` is bound to elem
      keypress: () -> # `this` is bound to elem
      t:100 # typing interval
      e:0.04 # this never gets used, but it takes 2 bytes off!
    , options)

    return @each ->
      elem = @
      jQuery(elem).queue ->

        attr = if elem.tagName is 'input'.toUpperCase() or
            elem.tagName is 'textarea'.toUpperCase()
          'value'
        else
          'innerHTML'

        (backsp = (n) ->
          if n # > 0
            elem[attr] = elem[attr].slice 0, -1
            settings.keypress.call elem
            setTimeout (-> backsp n-1), Math.random()*settings.t
          else
            settings.callback.call elem
            jQuery(elem).dequeue()
          return
        )(num)


  typetype: (txt, options) ->
    settings = jQuery.extend(
      callback: () -> # `this` is bound to elem
      keypress: () -> # `this` is bound to elem
      t:100 # typing interval
      e:0.04 # error probability
    , options)

    interval = (i) -> Math.random() * settings.t * (
      if txt[i-1] is txt[i] then 1.6
      else if txt[i-1] is '.' then 12
      else if txt[i-1] is '!' then 12
      else if txt[i-1] is '?' then 12
      else if txt[i-1] is '\n' then 12
      else if txt[i-1] is ',' then 8
      else if txt[i-1] is ';' then 8
      else if txt[i-1] is ':' then 8
      else if txt[i-1] is ' ' then 3
      else 2
    )

    return @each ->
      elem = @
      jQuery(elem).queue -> # this function goes into the 'fx' queue.

        attr = if elem.tagName is 'input'.toUpperCase() or
            elem.tagName is 'textarea'.toUpperCase()
          'value'
        else
          'innerHTML'

        append = (str, cont) ->
          if str # > 0
            elem[attr] += str[0]
            settings.keypress.call elem
            setTimeout (-> append str.slice(1), cont), settings.t
          else
            cont()
          return

        backsp = (num, cont) ->
          if num # > 0
            elem[attr] = elem[attr].slice 0, -1 # inlined delchar function
            settings.keypress.call elem
            setTimeout (-> backsp num-1, cont), settings.t
          else
            cont()
          return

        (typeTo = (i) ->
          if i <= txt.length
            afterErr = -> setTimeout (-> typeTo i), interval(i)
            r = Math.random() / settings.e

            # omit character, recover after 4 more chars
            if r<0.3 and txt[i-1] isnt txt[i] and i+4<txt.length
              append txt.slice(i,i+4), -> backsp 4, afterErr

            # hold shift too long
            else if r<0.7 and i>1 and /[A-Z]/.test txt[i-2] and i+4<txt.length
              append txt[i-1].toUpperCase()+txt.slice(i,i+4), ->
                backsp 5, afterErr

            # omit character, recover immediately
            else if r<0.5 and txt[i-1] isnt txt[i] and i<txt.length
              append txt[i], -> backsp 1, afterErr

            # swap two characters
            else if r<1.0 and txt[i-1] isnt txt[i] and i<txt.length
              append txt[i]+txt[i-1], -> backsp 2, afterErr

            # forget to press shift
            else if r<0.5 and /[A-Z]/.test txt[i]  #uppercase letter coming up
              append txt[i].toLowerCase(), -> backsp 1, afterErr

            # just insert the correct character!
            else
              elem[attr] += txt[i-1]
              settings.keypress.call elem
              setTimeout (-> typeTo i+1), interval(i)
          else
            settings.callback.call elem
            jQuery(elem).dequeue()
          return
        )(1)
