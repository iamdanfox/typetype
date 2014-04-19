($ = jQuery).fn.extend
  # txt: string to insert into every matched element
  # callback: function() to be called when txt has been inserted into each elem
  # keypress: function(index) called after every (correct) keypress
  typetype: (txt, keypress) ->

    # function returns the delay before the next character
    interval = (index) ->
      return Math.random() * 100 * (
        if txt[index-1] is txt[index] then 1.6
        else if txt[index-1] is '.' then 12
        else if txt[index-1] is '!' then 12
        else if txt[index-1] is '\n' then 12
        else if txt[index-1] is ',' then 8
        else if txt[index-1] is ';' then 8
        else if txt[index-1] is ' ' then 3
        else 2
      )

    # combined promise of all of them
    # return $.when deferreds... # ie $.when(d1, d2)   NOT   $.when([d1,d2])
    return $.when.apply($, for elem in @
      do (elem) ->
        # ensure we 'type' into the right thing
        attr = if elem.tagName is 'input'.toUpperCase() or elem.tagName is 'textarea'.toUpperCase()
          'value'
        else
          'innerHTML'

        append = (str, cont) ->
          if str.length # > 0
            elem[attr] += str[0]
            setTimeout (-> append str.slice(1), cont), 100
          else
            cont()
          return

        backsp = (num, cont) ->
          if num # > 0
            elem[attr] = elem[attr].slice 0, -1 # inlined delchar function
            setTimeout (-> backsp num-1, cont), 100
          else
            cont()
          return

        deferred = $.Deferred(
          (typeTo = (i) ->
            if txt.length > i
              r = Math.random()
              afterErr = -> setTimeout (-> typeTo i), interval i

              # omit character, recover after
              if 0.04 * 0.3>r and txt[i-1] isnt txt[i]
                append txt.slice(i,i+4), -> backsp 4, afterErr
              else if 0.04 * 0.5>r and txt[i-1] isnt txt[i]
                append txt[i], -> backsp 1, afterErr
              # swap two characters
              else if 0.04 * 0.8>r and txt[i-1] isnt txt[i]
                append txt[i]+txt[i-1], -> backsp 2, afterErr
              # hold shift too long
              else if 0.04 * 1.0>r and i>1 and txt[i-2] is txt[i-2].toUpperCase()
                append txt[i-1].toUpperCase()+txt[i], -> backsp 2, afterErr
              else
                elem[attr] += txt[i-1]
                keypress.call elem, i if keypress
                setTimeout (-> typeTo i+1), interval(i)
            else
              deferred.resolve()
            return
          )(1)
        )
    )
