argv = (optimist = require('optimist'))
	.default('port', 8080)
	.boolean(['help', 'version'])
	.usage([
		'Usage:',
		'    kaldr [--port <number>]'
	].join('\n'))
	.describe
		version : 'Show version and exit'
		help    : 'Show help and exit'
		port    : 'Use specified port'
	.argv

if argv.help
	optimist.showHelp()
	process.exit()

if argv.version
	console.log('0.0.1')
	process.exit()

(Crixalis = require('crixalis'))
	.plugin('compression')
	.router
		url     : '/kaldr.log'
		methods : ['GET', 'HEAD']
	.to ->
		if @cookies.message
			console.log decodeURIComponent @cookies.message

		@code = 204
	.set
		url: '/kaldr.frame'
	.to ->
		# TODO: cache-control
		@body = frame

Crixalis.on 'auto', ->
	@headers['Connection'] = 'close'
	@select()

Crixalis.on 'default', ->
	if @is_head or @is_get
		@code = 404
		@body = 'Not Found'
	else
		@code = 405
		@body = 'Not allowed'
		@headers['Allowed'] = 'GET, HEAD'

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

server.maxConnections = 512

process.on 'SIGINT', server.close.bind server
