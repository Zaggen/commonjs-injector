# Private Shared data
path = require('path')
cwd = process.cwd()
definedModule = null
config = {bypassInjection: true}

# Module
self =
  inject: (moduleWrapperFn)->
    definedModule = null
    moduleWrapperFn.import = self._import
    definedModule = if config.bypassInjection then moduleWrapperFn.call(moduleWrapperFn) else moduleWrapperFn.bind(moduleWrapperFn)

  getModule: ->
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

  getStatus: ->
    return config

# We define our public api inside the injector fn itself
injector = self.inject
injector.getModule = self.getModule
injector.bypassInjection = self.bypassInjection
injector.getStatus = self.getStatus


module.exports = injector