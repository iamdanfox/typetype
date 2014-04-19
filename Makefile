all: typetype.js

typetype.js:
	coffee -c typetype.coffee

gz: typetype.js
	uglifyjs typetype.js -cmo typetype.min.js
	gzip --to-stdout --best --keep -n typetype.min.js > gz
	wc -c gz
	rm gz
