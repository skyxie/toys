var factorial = function(logger, start) {
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

module.exports = factorial;