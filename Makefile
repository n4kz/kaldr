compile: lib/main.coffee
	echo '#!/usr/bin/env node' > bin/kaldr
	coffee --compile --bare --print lib/main.coffee >> bin/kaldr

test: compile
	coffee --compile t/lib/*.coffee t/*.coffee
	bin/kaldr --port 31337 &
	sleep 1
	vows --tap t/*.js
	killall 'kaldr [31337]'
	
clean:
	rm t/*.js t/lib/*.js

.ONESHELL: test
