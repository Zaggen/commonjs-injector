injector = require('def-inc').Module ->
  # Private Shared data
  definedModule = null
  config = {bypassInjection: true}
  ENV = 'production'
  path = require('path')
  cwd = process.cwd()

  ###*
  * @public
  * Sets a wrapper to add variables that use @import inside the passed fn to require modules,
  * this allows to inject dependencies via the fn wrapper instead of the actually required
  * modules.
  * @param {function} wrapperFn - Function where the return value is what is exported later
  ###
  @set = (wrapperFn)->
    # We add the import method to the passed fn to allow the end user to call it with in that fn
    wrapperFn.import = _wrapperImport
    wrapperFn.importGlobal = _importGlobal
    definedModule = if config.bypassInjection then wrapperFn.call(wrapperFn) else wrapperFn.bind(wrapperFn)
    definedModule.__injectorWrapper__ = true # Used by @import to check if the imported module is an injector wrapper

  ###*
  * @public
  * Returns the defined module, which could be the wrapper fn defined in the @set method
  * or what ever was returned from that function, depending of the setting of the byPassInjection option
  * in the config object.
  ###
  @get = ->
    t = definedModule
    definedModule = null
    return t

  ###*
  * @public
  * When defined as true (default), whenever you set an injector wrapper, you set the defined module
  * to whatever is returned by that wrapper, and when set to false you get the wrapper instead. This
  * wrapper function is what allows you to inject dependencies by passing a single object to it
  ###
  @bypassInjection = (boolean)->
    config.bypassInjection = boolean
    return this

  ###*
  * @public
  * Lets you set in a more declarative way that you want to bypass or not the injection system.
  * @example require('commonjs-injector').setEnv('testing') should be used before running your
  * test, and a regular require without .setEnv or require('commonjs-injector').setEnv('production')
  * will set to true the bypassing.
  ###
  @setEnv = (environment)->
    ENV = environment.toLowerCase()
    switch ENV
      when "production" then  config.bypassInjection = true
      when "testing" then  config.bypassInjection = false
      else
        errMsg = 'You should set the environment of the injector as either testing or production'
        throw new Error errMsg

    return this

  @getEnv = -> ENV

  ###*
   * @public
   * Mimics node require behavior, with some subtle differences:
   * Files are required relative to the cwd
   ###
  @import = (pathFragments...)->
    _import(pathFragments)

  ###*
  * @private
  * This function is added to the wrapperFn (i.e wrapperFn.import) to use instead of the node.js
  * require function, this allows to bypass the actual module requiring by injecting the module
  * in the dependencies obj of the wrapperFn.
  ###
  _wrapperImport = (pathFragments...)->
    moduleName = _getModuleName(pathFragments)
    # @dependencies refers to the one defined in the wrapperFn not in the injector module
    if @dependencies?[moduleName]?
      return @dependencies[moduleName]
    else
      _import(pathFragments)

  _getModuleName = (pathFragments)->
    moduleName = pathFragments[pathFragments.length - 1].split('/').pop()

  _import = (pathFragments)->
    fragsLen = pathFragments.length

    # When no slashes found we assume is an npm module
    isNpmModule = pathFragments[0].indexOf('/') is -1
    # When a single argument is provided to the import fn
    # we check if is an npm module, if not we assume a regular
    # one and provide the cwd as the base of the path
    if fragsLen is 1
      if isNpmModule
        filePath = pathFragments[0]
      else
        pathFragments.splice(0, 0, cwd)
        filePath = path.resolve.apply(@, pathFragments)
    else
      filePath = path.resolve.apply(@, pathFragments)

    module = require(filePath)
    # When the imported/required module is being wrapped by an injector fn, and the env is testing
    # we should get its contents (The actual module, not the wrapper).
    if module.__injectorWrapper__?
      module = module()
    return module

  ###*
  * @private
  * This function is added to the wrapperFn (i.e wrapperFn.importGlobal) to define global variables
  * as local ones, this allows to inject whatever we want in wrapperFn as long as we use the same name.
  * @example @importGlobal('async') will call global.async internally or the injected value
  * @TODO Should allow subobject keys, meaning that you should be able to call @importGlobal('someGloba.key.anotherKey'),
  * which right now you can't. Just first lvl globals.
  ###
  _importGlobal = (globalName)->
    # @dependencies refers to the one defined in the wrapperFn not in the injector module
    if @dependencies?[globalName]?
      @dependencies[globalName]
    else
      global[globalName]


module.exports = injector