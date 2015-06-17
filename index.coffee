path = require('path')
cwd = process.cwd()

_import = (pathFragments...)->
  fragsLen = pathFragments.length
  if fragsLen is 1 then pathFragments.splice(0, 0, cwd)

  moduleName = pathFragments[fragsLen - 1].split('/').pop()

  if @dependencies?[moduleName]?
    @dependencies[moduleName]
  else
    filePath = path.resolve.apply(@, pathFragments)
    #return require.main.filename
    require(filePath)


definedModule = null

injector = (moduleWrapperFn)->
  #definedModule = null
  moduleWrapperFn.import = _import
  ###moduleWrapperFn.export = (module, exportable)->
    module.export = {asd: 'asd'}###
  definedModule = moduleWrapperFn.call(moduleWrapperFn)
  #injectorRunner = _injectorRunner.bind(moduleWrapperFn)
  #exportable = if injector.config.autoExport then injectorRunner() else injectorRunner
  #exportable = if _config.bypassInjection is true then moduleWrapperFn() else moduleWrapperFn

injector.getModule = ->
  t = definedModule
  definedModule = null
  return t


###_injectorRunner = (deps)->
  moduleWrapperFn = @
  moduleWrapperFn.call(moduleWrapperFn, deps)
  for own key, exportedAttr of moduleWrapperFn
    unless key is 'import' or key is 'dependencies'
      return exportedAttr###

_config =
  autoExport: true
  bypassInjection: true

injector.bypassInjection = (boolean = true)->
  _config.bypassInjection = boolean


module.exports = injector