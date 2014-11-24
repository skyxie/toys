var _ = require('underscore');
var commander = require('commander');
var winston = require('winston');

var fs = require('fs');

var factorialEventloop = require('./factorial_eventloop');
var factorialRecursive = require('./factorial_recursive');

var loggerTransport = new winston.transports.Console({
  "level" : (process.env.LOG_LEVEL || 'info'),
  "dumpExceptions" : true,
  "showStack" : true,
  "timestamp" : true,
  "colorize" : true
});
var logger = new winston.Logger({"transports" : [ loggerTransport ]});

commander.version('0.0.1')
  .option('--factorialEventloop [x]', 'Calculate factorials using event loop up to x')
  .option('--factorialRecursive [x]', 'Calculate factorials using recursive calls on stack up to x')
  .option('--readFile [file]', 'Simultaneously read local file')
  .parse(process.argv);

if (commander.readFile) {
  var reader = fs.createReadStream(commander.readFile);
  var chunks = [];
  reader.on('data', function(chunk) {
    logger.debug("Read chunk "+chunks.length+" of size "+chunk.length);
    chunks.push(chunk);
  });
  reader.on('end', function() {
    logger.debug("Reading complete");
  })
}

if (commander.factorialEventloop) {
  _.each(_.range(commander.factorialEventloop), function(i) {
    logger.info(i+") Start "+i+"!");
    factorialEventloop(logger, i, function(result) {
      logger.info(i+") End "+i+"! = "+result);
    });
  });
} else if (commander.factorialRecursive) {
  _.each(_.range(commander.factorialRecursive), function(i) {
    logger.info(i+") Start "+i+"!");
    var result = factorialRecursive(logger, i);
    logger.info(i+") End "+i+"! = "+result);
  });
}
