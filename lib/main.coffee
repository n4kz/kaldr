argv = (optimist = require('optimist'))
	.default('port', 8080)
	.default('limit', 256)
	.boolean(['help', 'version', 'agent'])
	.usage([
		'Usage:',
		'    kaldr [--port <number>] [--limit <number>] [--agent]',
		'    kaldr --version',
		'    kaldr --help'
	].join('\n'))
	.describe
		version : 'Show version and exit'
		help    : 'Show help and exit'
		port    : 'Use specified port'
		agent   : 'Append user agent to each message'
		limit   : 'Concurrent connections limit'
	.argv

if argv.help
	optimist.showHelp()
	process.exit()

if argv.version
	console.log(require('../package').version)
	process.exit()

(Crixalis = require('crixalis'))
	.router
		methods : ['GET', 'HEAD']
	.from('/kaldr.log').to ->
		if @cookies.message
			message = decodeURIComponent(@cookies.message)

			if argv.agent
				message += ' '
				message += @req.headers['user-agent']

			console.log(message)

		@code = 204
	.from('/kaldr.frame').to ->
		@view = 'html'
		@body = frame

# Add Connection header to all responses
Crixalis.on 'auto', ->
	@headers['Connection'] = 'close'
	@select()

# Default handler
# 404 for unknown URI
# 405 for unknown methods
Crixalis.on 'default', ->
	if @is_head or @is_get
		@code = 404
	else
		@code = 405
		@headers['Allowed'] = 'GET, HEAD'

# Reset view
Crixalis.view = null

frame = """
<!DOCTYPE html><script>(function (_, $) {
	window.onhashchange = function () {
		var data = _.hash.replace(/^#/, '');

		if (data) {
			$.cookie = 'message=' + encodeURIComponent(data);
			(new Image).src = _.href.replace(/frame.*$/, 'log');
			$.cookie = 'message=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
			_.hash = '';
		}
	}
}(location, document))</script>
""".replace(/[\n\t]+/g, '')

(server = Crixalis.start('http', argv.port))
	.on('close', process.exit)
	.maxConnections = argv.limit

process.on('SIGINT', -> server.close())
process.title = "kaldr [#{argv.port}]"
