# commonjs-injector
Dependency injection module system


## Example using a sails.js model and def-inc module

- Require the injector globally so there is a single location to modify the configuration of the injector.
```coffeescript
# App start point
global.injector = require('commonjs-injector')
injector.byPassInjection(true) # Default behavior
```
- Use it as a wrapper of your module, it will work pretty much the same as a current commonjs module, with the exception
of the injector call, and that calls to require should be make throught @, so we can use the injector version of the require fn.
```coffeescript
# api/abstract/AuthModel.coffee
injector (@dependencies)->
  # Module Dependencies
  def = @import('def-inc')

  # Module
  @authModel = def.Obj(
    encrypPassword: ->
      #some code
  )

module.exports = injector.getModule()
```
- Here we require more modules, @require, works exactly the same as require which this fn uses internally.
```coffeescript
# api/models/Product.coffee
injector (@dependencies)->
  # Module Dependencies
  def       = @import('def-inc')
  baseModel = @import(__dirname, './abtract/baseModel') # Relative to the folder
  AuthModel = @import('./abstract/AuthModel') # Relative to cwd

  # Module
  @products = def.Obj(
    include_: [baseModel, AuthModel]
    attributes:
      name: {type: 'string', required: yes,  unique: true}
      description: {type: 'string'}
      slug: {type: 'string'}

    schema: true

    beforeCreate: (values, next)->
      values.slug = Tools.slugify(values.name)
      next()
  )

module.exports = injector.getModule()
```
### Inject dependencies
- Now in our tests, we configure the injector to use externally injected modules, this means, that every call to require, should return a function that accepts an object, which keys are the name of the module (filename) and its values are the module itself (or a mock obj, or anything you want), you can inject 0 or more dependencies, those that are not specified will use the ones defined in the module itself.
```coffeescript
global.injector.byPassInjection(false)

defMock = {Obj: -> console.log 'mocked def'}
authModelMock = {}

baseModel = require('./abtract/baseModel')({
 'AuthModel': authModelMock,
 'def-inc': defMock
})
```