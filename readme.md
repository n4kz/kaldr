# Kaldr

Simple logger for client-side errors

# Server

	kaldr --port 3000 > client.log &

# Client

Load kaldr
```html
<iframe id="#logger" src="http://localhost:3000/kaldr.frame#" style="display:none"></iframe>
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
