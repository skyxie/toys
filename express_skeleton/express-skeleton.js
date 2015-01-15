var fs = require('fs')
  , express = require('express')
  , winston = require('winston')
  , expressWinston = require('express-winston')
  , EventLoopLagFunction = require('event-loop-lag')
  , memwatch = require('memwatch')
  , multer = require('multer')
  , commander = require('commander');

commander.version('0.0.1')
  .option('--multer', 'Use multer instead of bodyParser')
  .parse(process.argv);

var loggerTransport = new winston.transports.Console({
  level : 'debug',
  dumpExceptions : true,
  showStack : true,
  colorize : true
});

var logger = new winston.Logger({transports: [loggerTransport] });

 // Start initial HeapDiff
var hd = new memwatch.HeapDiff();
memwatch.on('stats', function(stats) {
  logger.debug("estimated_base="+stats.estimated_base);
  var diff = hd.end();
  logger.debug("HeapDiff_change="+diff.change.size_bytes);
  hd = null;                    // Explicitly free previous HeapDiff object
  hd = new memwatch.HeapDiff(); // Create new HeapDiff object
});

var lag = EventLoopLagFunction(1000);
setInterval(function() {
  logger.debug("event_loop_lag="+lag());
}, 1000);

var app = express();

app.use(expressWinston.logger({"transports" : [loggerTransport] }));

if (commander.multer) {
  logger.info("USING multer");
  app.use(multer({"dest" : "/tmp/"}));
} else {
  logger.info("USING bodyParser");
  app.use(express.bodyParser({"keepExtensions" : true, "uploadDir" : "/tmp"}));
}
app.use(express.methodOverride());
app.use(app.router);

app.use(expressWinston.errorLogger({"transports": [ loggerTransport ]}));

app.post('/(files/)?upload', function(req, res) {
  logger.info("INSIDE UPLOAD FUNCTION");
  if (req.files.Filedata){
    fs.unlink(req.files.Filedata.path, function() {
      logger.info("REMOVING FILE %s", req.files.Filedata.path);
      res.send(200);
    });
    return;
  }
  res.send(200);
});

app.listen(8000);

logger.info("EXPRESS SKELETON STARTED");