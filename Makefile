all: jquery.typetype.js

jquery.typetype.js:
	coffee -cb jquery.typetype.coffee

gz: jquery.typetype.js
	uglifyjs jquery.typetype.js -cmo jquery.typetype.min.js
	gzip --to-stdout --best --keep -n jquery.typetype.min.js > gz
	wc -c gz
	rm gz
