# Kaldr

Simple and fast logger for client-side errors

# Installation

```bash
# Global
npm -g install kaldr

# Local
npm install kaldr
```

If you have chosen local installation, check your `PATH` environment variable. `npm` creates symlinks to
all binaries in `~/node_modules/.bin` hidden folder. So you may want to prepend it to `PATH`.

# Server setup

```bash
# Log to console
kaldr

# Log to file
kaldr >> client.log &

# Test kaldr
curl -b 'message=Hello, World!' localhost:8080/kaldr.log
```

# Client setup

Load kaldr
```html
<iframe id="#logger" src="http://localhost:8080/kaldr.frame#" style="display:none"></iframe>
```

Send message to kaldr
```js
var logger = document.getElementById('logger'),
	src = logger.getAttribute('src').split('#')[0];

window.onerror = function (mesage, file, line) {
	logger.setAttribute('src', src + '#' + message + ' in ' + file + ' at line ' + line);
};
```

# Copyright and License

Copyright 2013 Alexander Nazarov. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
