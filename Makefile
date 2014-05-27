all: jquery.typetype.min.js

jquery.typetype.js: jquery.typetype.coffee
	coffee -cb jquery.typetype.coffee

jquery.typetype.min.js: jquery.typetype.js
	uglifyjs jquery.typetype.js --compress pure_getters --mangle > jquery.typetype.min.js

gz: jquery.typetype.min.js
	gzip --to-stdout --best --keep -n jquery.typetype.min.js | wc -c

zop: jquery.typetype.min.js # zopfli is Google's zlib compression algorithm: `brew install zopfli` to try it.
	zopfli -c --i50 --deflate jquery.typetype.min.js | wc -c
