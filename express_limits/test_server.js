var express = require('express');
var winston = require('winston');
var expressWinston = require('express-winston');

var factorial = require('../eventloop_demo/factorial_eventloop');

var loggerTransport = new winston.transports.Console({
  "level" : (process.env.LOG_LEVEL || 'info'),
  "dumpExceptions" : true,
  "showStack" : true,
  "colorize" : true
});

var logger = new winston.Logger({"transports" : [ loggerTransport ]});

var app = express();

app.use(expressWinston.logger({"transports" : [ loggerTransport ]}));
app.use(expressWinston.errorLogger({"transports" : [ loggerTransport ]}));

var logger = new winston.Logger({"transports" : [ loggerTransport ]});

app.get('/rand', function(req, res) {
  var randomNumber = Math.random();
  logger.debug("Got random number %d", randomNumber);
  res.status(200).send({'result' : randomNumber});
});

app.get('/factorial/:max', function(req, res) {
  var max = req.params.max;
  factorial(logger, max, function(factorial) {
    res.status(200).send({'factorial_of': max, 'result': factorial});
  });
});

var port = process.env.PORT || 8000;

app.listen(port, function() {
  logger.info("Server running on port %d", port);
});
