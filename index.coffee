# Private Shared data
path = require('path')
cwd = process.cwd()
definedModule = null
config = {bypassInjection: true}

# Module
self =
  set: (wrapperFn)->
    definedModule = null
    # We add the import method to the passed fn to allow the end user to call it with in that fn
    wrapperFn.import = self._import
    wrapperFn.importGlobal = self._importGlobal
    definedModule = if config.bypassInjection then wrapperFn.call(wrapperFn) else wrapperFn.bind(wrapperFn)

  # Returns the fn wrapper or defined module
  get: ->
    t = definedModule
    definedModule = null
    return t

  bypassInjection: (boolean)->
    config.bypassInjection = boolean

  _import: (pathFragments...)->
    fragsLen = pathFragments.length
    moduleName = pathFragments[fragsLen - 1].split('/').pop()

    if @dependencies?[moduleName]?
      @dependencies[moduleName]
    else
      isNpmModule = pathFragments[0].indexOf('/') is -1
      if fragsLen is 1
        if isNpmModule
          filePath = pathFragments[0]
        else
          pathFragments.splice(0, 0, cwd)
          filePath = path.resolve.apply(@, pathFragments)
      else
        filePath = path.resolve.apply(@, pathFragments)

      require(filePath)

  _importGlobal: (globalName)->
    console.log 'deps', @dependencies
    if @dependencies?[globalName]?
      @dependencies[globalName]
    else
      console.log globalName
      console.log global[globalName]
      global[globalName]


# We define our public api inside the injector fn itself
injector =
  set: self.set
  get: self.get
  bypassInjection: self.bypassInjection

module.exports = injector