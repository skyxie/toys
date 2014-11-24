var http = require('http');
var path = require('path');

var Async = require('async');
var commander = require('commander');
var _ = require('underscore');
var winston = require('winston');

var loggerTransport = new winston.transports.Console({
  "level" : (process.env.LOG_LEVEL || 'info'),
  "dumpExceptions" : true,
  "showStack" : true,
  "colorize" : true
});

var logger = new winston.Logger({"transports" : [ loggerTransport ]});

commander.version('0.0.1')
  .option('-p, --path [path]', 'Request test serve on given path')
  .option('-c, --concurrency [concurrency]', 'Run c concurrent requests')
  .parse(process.argv);

Async.parallel(
  _.map(_.range(commander.concurrency), function(i) {
    return function(callback) {
      Async.waterfall([
        function createGetRequest(cb) {
          var requestOpts = {
            "host" : "127.0.0.1",
            "port" : process.env.PORT || 8000,
            "path" : path.join(commander.path, i.toString()),
            "method" : "get"
          };

          var get = http.request(requestOpts, function(response) { cb(null, response); });
          logger.debug("%d) sending request", i);
          get.end();
        },
        function extractResponseBody(response, cb) {
          var responseBody = '';
          response.on('data', function(chunk) {
            logger.debug("%d) received chunk of size: %d", i, chunk.length);
            responseBody += chunk;
          });
          response.on('error', cb);
          response.on('end', function() {
            logger.debug("%d) get request complete", i);
            cb(null, responseBody);
          });
        },
        function parseResult(responseBody, cb) {
          try {
            parsedBody = JSON.parse(responseBody);
            cb(null, parsedBody.result);
          } catch (e) {
            cb(new Error("Could not parse JSON from: "+responseBody));
          }
        }
      ], function(error, result) {
        if (error) {
          logger.error("%d) ERROR: %s", i, error.message)
          result = null;
        }
        callback(null, result);
      });
    };
  }),
  function(error, results) {
    if (error) {
      logger.error("ERROR: %s", error.message);
    } else {
      logger.info("RESULTS: [%s]", results.join(","));
    }
  }
);
