assert = require 'assert'
vows   = require 'vows'
fetch  = require './lib/fetch.js'
copy   = require './lib/copy.js'
spawn  = require('child_process').spawn
host   = '127.0.0.1'
port   = 31337
path   = '/kaldr.frame'

vows
	.describe('frame')
	.addBatch
		main:
			topic:
				host: '127.0.0.1'
				path: path
				port: port

			get:
				topic: (topic) ->
					params = copy topic
					params.method = 'GET'
					fetch params, @callback

					undefined

				response: (error, response) ->
					assert not error,                                   'No error set'
					assert.equal    response.statusCode, 200,           'Request completed'
					assert.include  response.headers, 'content-length', 'Content-Length present'
					assert.match    response.body, /script/i,           'Response body present'

			post:
				topic: (topic) ->
					params = copy topic
					params.method = 'POST'
					fetch params, @callback

					undefined

				response: (error, response) ->
					assert not error,                                   'No error set'
					assert.equal    response.statusCode, 405,           'Method not allowed'
					assert.include  response.headers, 'allowed',        'Allowed present'
					assert.isEmpty  response.body,                      'Response body is empty'

			head:
				topic: (topic) ->
					params = copy topic
					params.method = 'HEAD'
					fetch params, @callback

					undefined

				response: (error, response) ->
					assert not error,                                   'No error set'
					assert.equal    response.statusCode, 200,           'Method not allowed'
					assert.include  response.headers, 'content-length', 'Content-Length present'
					assert.isEmpty  response.body,                      'Response body is empty'

	.export module
