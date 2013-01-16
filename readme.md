# Kaldr

Simple logger for client-side errors

# Server

	kaldr --port 3000 > client.log &

# Client

```html
<iframe id="#logger" src="http://localhost:3000/kaldr.frame#" style="display:none"></iframe>
```

```js
var logger = document.getElementById('logger'),
	src = logger.getAttribute('src').split('#')[0];

window.onerror = function (mesage, file, line) {
	logger.setAttribute('src', src + '#' + message + ' in ' + file + ' at line ' + line)
};
```
