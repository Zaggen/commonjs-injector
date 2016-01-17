# commonjs-injector
Dependency injection module system


## Example using a sails.js model and def-inc module

- Require the injector globally so there is a single location to modify the configuration of the injector.
```coffeescript
# App start point
global.injector = require('commonjs-injector').setEnv('production')
```
- Use it as a wrapper of your module, it will work pretty much the same as a current commonjs module, with the
exception of the injector call, and that calls to @import that will work similar to node require()
```coffeescript
# api/abstract/AuthModel.coffee
injector.set (@dependencies)->
  # Module Dependencies
  def = @import('def-inc')

  # Module
  @authModel = def.Obj(
    encrypPassword: ->
      #some code
  )

module.exports = injector.get()
```

You can omit `injector.get()` by exporting what is returned by `injector.set`
```coffeescript
# api/abstract/AuthModel.coffee
module.exports = injector.set (@dependencies)->
  # Module Dependencies
  def = @import('def-inc')

  # Module
  authModel = def.Obj(
    encrypPassword: ->
      #some code
  )
  
  return authModel

```

- Here we import more modules, @import, works almost the same as require which this fn uses internally.
```coffeescript
# api/models/Product.coffee
injector.set (@dependencies)->
  # Module Dependencies
  def       = @import('def-inc')
  baseModel = @import(__dirname, './abtract/baseModel') # Relative to the folder
  AuthModel = @import('./abstract/AuthModel') # Relative to cwd
  roles     = @importGlobal('roles') # gets global.Roles

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

module.exports = injector.get()
```
### Inject dependencies
- Now in our tests, we configure the injector to use externally injected modules by setting its environment as testing,
this means, that every call to require, should return a function that accepts an object, which keys are the name of the
module (filename) and its values are the module itself (or a mock obj, or anything you want), you can inject 0 or more
dependencies, those that are not specified will use the ones defined in the module itself.
```coffeescript
global.injector.setEnv('testing')

defMock = {Obj: -> console.log 'mocked def'}
authModelMock = {}
rolesMock = {}

baseModel = require('./abtract/baseModel')({
 'AuthModel': authModelMock,
 'def-inc': defMock
 'roles': rolesMock
})
```

***Caveat:*** The whole idea of this module is to use all your modules as you normally do, and when you want to test,
you disable the bypassing by changing the environment or directly calling "byPassInjection(boolean)", but bare in mind 
that node require caches files already required, so setting injector.byPassInjection(false) after requiring a module
that uses the injector will use the default value if called later and not the new setted value, this is not a bug,
is the expected behavior since we don't want to disable caching, in that case you can remove the item from the cache.