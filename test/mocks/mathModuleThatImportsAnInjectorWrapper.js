// Generated by CoffeeScript 1.11.1
(function() {
  injector.set(function() {
    var math, pi;
    pi = this["import"](__dirname, './injectorPiModule');
    math = {
      square: function(x) {
        return x * x;
      },
      pi: pi
    };
    return math;
  });

  module.exports = injector.get();

}).call(this);

//# sourceMappingURL=mathModuleThatImportsAnInjectorWrapper.js.map
