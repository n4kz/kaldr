# TODO: command-line arguments

(Crixalis = new require('crixalis')())
	.plugin('./plugins/compression')
	.router
		url     : '/kaldr.log'
		methods : ['GET']
	.to ->
		if @cookies.message
			console.log decodeURIComponent @cookies.message

		@code = 204
	.set
		# TODO: cache-control
		url: '/kaldr.frame'
	.to ->
		@body = frame

frame = """
<!DOCTYPE html>
<script>(function (_, $) {
	window.onhashchange = function () {
		var data = _.hash.replace(/^#/, '')

		if (data) {
			$.cookie = 'message=' + encodeURIComponent(data)
			Image().src = _.href.replace(/frame.*$/, 'log')
			$.cookie = 'message=; expires=Thu, 01 Jan 1970 00:00:01 GMT;'
			_.hash = ''
		}
	}
}(location, document))</script>
""".replace /\t+/g, ''

server = require('http')
	.createServer(Crixalis.handler())
	.listen(process.argv[2] or 8080)
	.on('close', process.exit)

process.on 'SIGINT', server.close.bind server
