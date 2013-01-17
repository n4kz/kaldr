argv = (optimist = require('optimist'))
	.default('port', 8080)
	.default('limit', 256)
	.boolean(['help', 'version'])
	.usage([
		'Usage:',
		'    kaldr [--port <number>][--limit <number>]'
	].join('\n'))
	.describe
		version : 'Show version and exit'
		help    : 'Show help and exit'
		port    : 'Use specified port'
		limit   : 'Concurrent connections limit'
	.argv

if argv.help
	optimist.showHelp()
	process.exit()

if argv.version
	console.log('0.0.1')
	process.exit()

(Crixalis = require('crixalis'))
	.router
		methods : ['GET', 'HEAD']
	.from('/kaldr.log').to ->
		if @cookies.message
			console.log decodeURIComponent @cookies.message

		@code = 204
	.from('/kaldr.frame').to ->
		@body = frame

Crixalis.on 'auto', ->
	@headers['Connection'] = 'close'
	@select()

Crixalis.on 'default', ->
	if @is_head or @is_get
		@code = 404
	else
		@code = 405
		@headers['Allowed'] = 'GET, HEAD'

	@render()

frame = """
<!DOCTYPE html><script>(function (_, $) {
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
	.createServer(Crixalis.handler)
	.listen(argv.port)
	.on('close', process.exit)

server.maxConnections = argv.limit

process.on 'SIGINT', server.close.bind server
process.title = 'kaldr [' + argv.port + ']'
