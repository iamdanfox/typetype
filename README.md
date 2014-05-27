[![Screencast](screencast.gif)][1]

typetype
========

typetype is a jQuery plugin that simulates a human typing.



Usage
-----

Include jQuery and [jquery.typetype.min.js][2] (just 578 bytes gzipped).

You can then append some text to `textarea`s, `input`s or other HTML elements.

```javascript
$('textarea').typetype('Some text that you want to demo')
```



Customize the typing
--------------------

```javascript
$('textarea').typetype(
  'Text to append',
  {
    e: 0.04, // error rate. (use e=0 for perfect typing)
    t: 100, // interval between keypresses
    keypress: function (){
      // called after every keypress (this may be an erroneous keypress!)
    },
    callback: function (){
      // the `this` keyword is bound to the particular element.
    }
  }
)
```

`backspace` jQuery plugin
-------------------------

Similarly, you can backspace text from an element in a believable way.

```javascript
$('textarea').backspace(
  14, // number of chars to backspace
  {
    t: 100, // interval between keypresses
    keypress: function (){ },
    callback: function (){ }
  }
)
```

Combined with jQuery animations
-------------------------------

Both plugins can be chained to make very readable, sequential jQuery:

```javascript
$('textarea')
  .typetype('Hello, world!')
  .delay(1000)
  .typetype('\n\nGoodbye.')
  .backspace(25)
  .fadeOut() // regular jQuery effects queue up nicely
```


Inspired by
-----------

@dmotz's delightful [TuringType][3].  I was also inspired by Daniel
LeCheminant's [StackOverflow in 4096 bytes][4].

I challenge anyone to make a smaller gzipped version! (`make gz` was useful)

[1]: http://iamdanfox.github.io/typetype/
[2]: http://iamdanfox.github.io/typetype/jquery.typetype.min.js
[3]: https://github.com/dmotz/TuringType
[4]: http://danlec.com/blog/stackoverflow-in-4096-bytes
