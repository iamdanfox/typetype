$.fn.extend

  backspace: (num, options) ->
    settings = $.extend(
      callback: () -> # `this` is bound to elem
      keypress: () -> # `this` is bound to elem
      t:100 # typing interval
      e:0.04 # this never gets used, but it takes 2 bytes off!
    , options)

    @each ->
      elem = @
      $(elem).queue ->
        backsp = (n, fakeparam) ->
          if n # > 0
            elem[if /(np|x)/i.test elem.tagName then 'value' else 'innerHTML'] = elem[if /(np|x)/i.test elem.tagName then 'value' else 'innerHTML'].slice 0, -1
            settings.keypress.call elem
            setTimeout (-> backsp n-1, fakeparam; return), settings.t
          else
            settings.callback.call elem
            $(elem).dequeue()
          return

        append = (fake, fakeyness) ->
          if fake # > 0
            elem[if /(np|x)/i.test elem.tagName then 'value' else 'innerHTML'] += fake[0]
            settings.keypress.call elem
            setTimeout (-> append fake.slice(1), fakeyness; return), settings.t
          else
            fakeyness()
          return

        backsp num
        return
      return


  typetype: (txt, options) ->
    settings = $.extend(
      callback: () -> # `this` is bound to elem
      keypress: () -> # `this` is bound to elem
      t:100 # typing interval
      e:0.04 # error probability
    , options)

    @each ->
      elem = @
      $(elem).queue -> # this function goes into the 'fx' queue.

        backsp = (num, cont) ->
          if num # > 0
            elem[if /(np|x)/i.test elem.tagName then 'value' else 'innerHTML'] = elem[if /(np|x)/i.test elem.tagName then 'value' else 'innerHTML'].slice 0, -1 # inlined delchar function
            settings.keypress.call elem
            setTimeout (-> backsp num-1, cont; return), settings.t
          else
            cont()
          return

        append = (str, cont) ->
          if str # > 0
            elem[if /(np|x)/i.test elem.tagName then 'value' else 'innerHTML'] += str[0]
            settings.keypress.call elem
            setTimeout (-> append str.slice(1), cont; return), settings.t
          else
            cont()
          return

        typeTo = (i) ->
          afterErr = -> setTimeout (-> typeTo i; return), (Math.random() * settings.t * (
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
          ))
          r = Math.random() / settings.e

          if txt.length >= i
            # omit character, recover after 4 more chars
            if 0.3 > r and txt[i-1] isnt txt[i] and txt.length > i+4
              append txt.slice(i,i+4), (-> backsp 4, afterErr; return)

            # hold shift too long
            else if 0.7 > r and i > 1 and /[A-Z]/.test txt[i-2] and txt.length > i+4
              append txt[i-1].toUpperCase()+txt.slice(i,i+4), (-> backsp 5, afterErr; return)

            # omit character, recover immediately
            else if 0.5 > r and txt[i-1] isnt txt[i] and txt.length > i
              append txt[i], (-> backsp 1, afterErr; return)

            # swap two characters
            else if 1.0 > r and txt[i-1] isnt txt[i] and txt.length > i
              append txt[i]+txt[i-1], (-> backsp 2, afterErr; return)

            # forget to press shift
            else if 0.5 > r and /[A-Z]/.test txt[i]  #uppercase letter coming up
              append txt[i].toLowerCase(), (-> backsp 1, afterErr; return)

            # just insert the correct character!
            else
              elem[if /(np|x)/i.test elem.tagName then 'value' else 'innerHTML'] += txt[i-1]
              settings.keypress.call elem
              setTimeout (-> typeTo i+1; return), (Math.random() * settings.t * (
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
              ))
          else
            settings.callback.call elem
            $(elem).dequeue()
          return
        typeTo 1
        return
      return
