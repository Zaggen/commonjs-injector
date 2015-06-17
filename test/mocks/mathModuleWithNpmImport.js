// Generated by CoffeeScript 1.9.3
(function() {
  injector.set(function(dependencies) {
    var def, math, pi;
    this.dependencies = dependencies;
    pi = this["import"](__dirname, './PiModule');
    def = this["import"]('def-inc');
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
