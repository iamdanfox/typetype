[![Screencast](typetype.gif)][1]

typetype
========

typetype is a jQuery plugin that simulates a human typing.



Usage
-----

Include jQuery and [typetype.min.js][2] (just 609 bytes gzipped):

```html
<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js" type="text/javascript"></script>
<script src="[some-path]/typetype.min.js" type="text/javascript"></script>
```

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
    ms: 100, // interval between keypresses
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
-----------------------

Similarly, you can backspace text from an element in a believable way.

```javascript
$('textarea').backspace(
  14, // number of chars to backspace
  {
    ms: 100, // interval between keypresses
    keypress: function (){ },
    callback: function (){ }
  }
)
```

[1]: http://iamdanfox.github.io/typetype/
[2]: http://iamdanfox.github.io/typetype/typetype.min.js
