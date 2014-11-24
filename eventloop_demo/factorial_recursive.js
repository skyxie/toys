var factorial = function(logger, start) {
  var factorialRecur = function(start, step) {
    if (step == 0) {
      logger.debug("%d) returning 1", start);
      return 1;
    } else {
      var nextStep = step - 1;
      logger.debug("%d) calculating %d * %d!", start, step, nextStep);
      return step * factorialRecur(start, nextStep);
    }
  };

  return factorialRecur(start, start);
};

module.exports = factorial;