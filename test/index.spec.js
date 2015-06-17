// Generated by CoffeeScript 1.9.3
(function() {
  var expect, mockPath, mockWithImportPath;

  expect = require('chai').expect;

  global.injector = require('../index');

  mockPath = require.resolve('./mocks/mathModule');

  mockWithImportPath = require.resolve('./mocks/mathModuleWithImport');

  describe('commonjs-injector Module', function() {
    describe('When bypassInjection is set to true (default)', function() {
      beforeEach(function() {
        return injector.bypassInjection(true);
      });
      it('should let you export a module as a regular node.js module', function() {
        var mathModule;
        mathModule = require(mockPath);
        expect(mathModule).to.be.an('object');
        expect(mathModule.square(5)).to.equal(25);
        return delete require.cache[mockPath];
      });
      return it('should let you use @import inside the injector fn to require modules', function() {
        var mathModule;
        mathModule = require(mockWithImportPath);
        expect(mathModule).to.be.an('object');
        expect(mathModule.pi).to.equal(Math.PI);
        return delete require.cache[mockWithImportPath];
      });
    });
    return describe('When bypassInjection is set to false', function() {
      beforeEach(function() {
        return injector.bypassInjection(false);
      });
      afterEach(function() {
        return delete require.cache[mockPath];
      });
      return it('should let you export a fn wrapper that accepts an object with dependencies', function() {
        var mathModule;
        mathModule = require('./mocks/mathModule');
        return expect(mathModule).to.be.an('function');
      });
    });
  });

}).call(this);

//# sourceMappingURL=index.spec.js.map