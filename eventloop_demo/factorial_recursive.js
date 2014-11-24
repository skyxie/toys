
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

var factorial = function(start) {
  var factorialRecur = function(start, step) {
    if (step == 0) {
      logger.debug(start+") returning 1");
      return 1;
    } else {
      logger.debug(start+") calculating "+step+" * "+(step-1)+"!");
      return step * factorialRecur(start, step-1);
    }
  };

  return factorialRecur(start, start);
};

_.each(_.range(y), function(i) {
  logger.info(i+") Start "+i+"!");
  var result = factorial(i);
  logger.info(i+") End "+i+"! = "+result);
});
