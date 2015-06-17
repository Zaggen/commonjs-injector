// Generated by CoffeeScript 1.9.3
(function() {
  injector.set(function(dependencies) {
    var math, pi;
    this.dependencies = dependencies;
    pi = this["import"](__dirname, './PiModule');
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

//# sourceMappingURL=mathModuleWithImport.js.map
