test: test-firefox test-chrome

test-firefox:
	node_modules/.bin/nightwatch

test-chrome:
	node_modules/.bin/nightwatch --env chrome
