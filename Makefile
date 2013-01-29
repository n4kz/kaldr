compile: lib/main.coffee
	echo '#!/usr/bin/env node' > bin/kaldr
	coffee --compile --lint --bare --print lib/main.coffee >> bin/kaldr
