// Generated by CoffeeScript 1.11.1
(function() {
  injector.set(function() {
    var def, math, pi;
    pi = this["import"](__dirname, './PiModule');
    def = this["import"]('def-type');
    math = def.Object({
      square: function(x) {
        return x * x;
      },
      pi: pi
    });
    return math;
  });

  module.exports = injector.get();

}).call(this);

//# sourceMappingURL=mathModuleWithNpmImport.js.map
