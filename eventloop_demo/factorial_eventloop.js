
var _ = require('underscore');
var winston = require('winston');

var loggerTransport = new winston.transports.Console({
  "level" : (process.env.LOG_LEVEL || 'info'),
  "dumpExceptions" : true,
  "showStack" : true,
  "timestamp" : true,
  "colorize" : true
});
var logger = new winston.Logger({"transports" : [ loggerTransport ]});

var y = process.argv.pop();

var factorial = function(start, cb) {
  var factorialRecur = function(start, step, factorial, cb) {
    if (step == 0) {
      logger.debug(start+") calling back "+factorial);
      cb(factorial);
    } else {
      setImmediate(function() {
        logger.debug(start+") calculating "+(step-1)+"!");
        factorialRecur(start, step-1, factorial*step, cb);
      });
    }
  };

  factorialRecur(start, start, 1, cb);
};

_.each(_.range(0, y), function(i) {
  logger.info(i+") Start "+i+"!");
  factorial(i, function(result) {
    logger.info(i+") End "+i+"! = "+result);
  });
});
