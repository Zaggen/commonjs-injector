// Generated by CoffeeScript 1.9.3
(function() {
  var ENV, config, cwd, definedModule, injector, path, self,
    slice = [].slice;

  path = require('path');

  cwd = process.cwd();

  definedModule = null;

  config = {
    bypassInjection: true
  };

  ENV = 'production';

  self = {
    set: function(wrapperFn) {
      definedModule = null;
      wrapperFn["import"] = self._import;
      wrapperFn.importGlobal = self._importGlobal;
      return definedModule = config.bypassInjection ? wrapperFn.call(wrapperFn) : wrapperFn.bind(wrapperFn);
    },
    get: function() {
      var t;
      t = definedModule;
      definedModule = null;
      return t;
    },
    bypassInjection: function(boolean) {
      config.bypassInjection = boolean;
      return this;
    },
    setEnv: function(environment) {
      var errMsg;
      ENV = environment.toLowerCase();
      switch (ENV) {
        case "production":
          config.bypassInjection = true;
          break;
        case "testing":
          config.bypassInjection = false;
          break;
        default:
          errMsg = 'You should set the environment of the injector as either testing or production';
          throw new Error(errMsg);
      }
      return this;
    },
    getEnv: function() {
      return ENV;
    },
    _import: function() {
      var filePath, fragsLen, isNpmModule, moduleName, pathFragments, ref;
      pathFragments = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      fragsLen = pathFragments.length;
      moduleName = pathFragments[fragsLen - 1].split('/').pop();
      if (((ref = this.dependencies) != null ? ref[moduleName] : void 0) != null) {
        return this.dependencies[moduleName];
      } else {
        isNpmModule = pathFragments[0].indexOf('/') === -1;
        if (fragsLen === 1) {
          if (isNpmModule) {
            filePath = pathFragments[0];
          } else {
            pathFragments.splice(0, 0, cwd);
            filePath = path.resolve.apply(this, pathFragments);
          }
        } else {
          filePath = path.resolve.apply(this, pathFragments);
        }
        return require(filePath);
      }
    },
    _importGlobal: function(globalName) {
      var ref;
      if (((ref = this.dependencies) != null ? ref[globalName] : void 0) != null) {
        return this.dependencies[globalName];
      } else {
        return global[globalName];
      }
    }
  };

  injector = {
    set: self.set,
    get: self.get,
    getEnv: self.getEnv,
    setEnv: self.setEnv,
    bypassInjection: self.bypassInjection
  };

  module.exports = injector;

}).call(this);

//# sourceMappingURL=index.js.map
