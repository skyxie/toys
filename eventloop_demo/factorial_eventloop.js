var factorial = function(logger, start, cb) {
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

module.exports = factorial;