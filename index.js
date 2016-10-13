// Generated by CoffeeScript 1.11.1
(function() {
  var injector,
    slice = [].slice;

  injector = require('def-type').Module(function() {
    var ENV, _getModuleName, _import, _importGlobal, _wrapperImport, config, cwd, definedModule, path;
    definedModule = null;
    config = {
      bypassInjection: true
    };
    ENV = 'production';
    path = require('path');
    cwd = process.cwd();

    /**
    * @public
    * Sets a wrapper to add variables that use @import inside the passed fn to require modules,
    * this allows to inject dependencies via the fn wrapper instead of the actually required
    * modules.
    * @param {function} wrapperFn - Function where the return value is what is exported later
     */
    this.set = function(wrapperFn) {
      wrapperFn["import"] = _wrapperImport;
      wrapperFn.importGlobal = _importGlobal;
      if (config.bypassInjection) {
        definedModule = wrapperFn.call(wrapperFn);
      } else {
        definedModule = function(dependencies) {
          wrapperFn.dependencies = dependencies;
          return wrapperFn.call(wrapperFn);
        };
        definedModule.__injectorWrapper__ = true;
      }
      return definedModule;
    };

    /**
    * @public
    * Returns the defined module, which could be the wrapper fn defined in the @set method
    * or what ever was returned from that function, depending of the setting of the byPassInjection option
    * in the config object.
     */
    this.get = function() {
      var t;
      t = definedModule;
      definedModule = null;
      return t;
    };

    /**
    * @public
    * When defined as true (default), whenever you set an injector wrapper, you set the defined module
    * to whatever is returned by that wrapper, and when set to false you get the wrapper instead. This
    * wrapper function is what allows you to inject dependencies by passing a single object to it
     */
    this.bypassInjection = function(boolean) {
      config.bypassInjection = boolean;
      return this;
    };

    /**
    * @public
    * Lets you set in a more declarative way that you want to bypass or not the injection system.
    * @example require('commonjs-injector').setEnv('testing') should be used before running your
    * test, and a regular require without .setEnv or require('commonjs-injector').setEnv('production')
    * will set to true the bypassing.
     */
    this.setEnv = function(environment) {
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
    };
    this.getEnv = function() {
      return ENV;
    };

    /**
     * @public
     * Mimics node require behavior, with some subtle differences:
     * Files are required relative to the cwd
     */
    this["import"] = function() {
      var pathFragments;
      pathFragments = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      return _import(pathFragments);
    };

    /**
    * @private
    * This function is added to the wrapperFn (i.e wrapperFn.import) to use instead of the node.js
    * require function, this allows to bypass the actual module requiring by injecting the module
    * in the dependencies obj of the wrapperFn.
     */
    _wrapperImport = function() {
      var moduleName, pathFragments, ref;
      pathFragments = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      moduleName = _getModuleName(pathFragments);
      if (((ref = this.dependencies) != null ? ref[moduleName] : void 0) != null) {
        return this.dependencies[moduleName];
      } else {
        return _import(pathFragments);
      }
    };
    _getModuleName = function(pathFragments) {
      var moduleName;
      return moduleName = pathFragments[pathFragments.length - 1].split('/').pop();
    };
    _import = function(pathFragments) {
      var filePath, fragsLen, isNpmModule, module;
      fragsLen = pathFragments.length;
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
      module = require(filePath);
      if (module.__injectorWrapper__ != null) {
        module = module();
      }
      return module;
    };

    /**
    * @private
    * This function is added to the wrapperFn (i.e wrapperFn.importGlobal) to define global variables
    * as local ones, this allows to inject whatever we want in wrapperFn as long as we use the same name.
    * @example @importGlobal('async') will call global.async internally or the injected value
    * @TODO Should allow subobject keys, meaning that you should be able to call @importGlobal('someGloba.key.anotherKey'),
    * which right now you can't. Just first lvl globals.
     */
    return _importGlobal = function(globalName) {
      var ref;
      if (((ref = this.dependencies) != null ? ref[globalName] : void 0) != null) {
        return this.dependencies[globalName];
      } else {
        return global[globalName];
      }
    };
  });

  module.exports = injector;

}).call(this);

//# sourceMappingURL=index.js.map
