var factorial = function(logger, start, cb) {
  var factorialRecur = function(start, step, factorial, cb) {
    if (step == 0) {
      logger.debug("%d) calling back %d", start, factorial);
      cb(factorial);
    } else {
      setImmediate(function() {
        var nextStep = step - 1;
        logger.debug("%d) calculating %d!", start, nextStep);
        factorialRecur(start, nextStep, factorial*step, cb);
      });
    }
  };

  factorialRecur(start, start, 1, cb);
};

module.exports = factorial;