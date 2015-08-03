expect = require('chai').expect
global.injector = require('../index.coffee')
mockPath = require.resolve('./mocks/mathModule.coffee')
mockWithImportPath = require.resolve('./mocks/mathModuleWithImport.coffee')
mockWithNpmImportPath = require.resolve('./mocks/mathModuleWithNpmImport.coffee')
mockWithInjectorImportPath = require.resolve('./mocks/mathModuleThatImportsAnInjectorWrapper.coffee')
global.PI = Math.PI
mockWithGlobalDep = require.resolve('./mocks/mockWithGlobalDep.coffee')

describe 'commonjs-injector Module', ->

  it 'should have a "set" method', ->
    expect(injector.set).to.be.a('function')

  it 'should have a "get" method', ->
    expect(injector.get).to.be.a('function')

  it 'should have an "import" method', ->
    expect(injector.import).to.be.a('function')

  it 'should have a "bypassInjection" method', ->
    expect(injector.bypassInjection).to.be.a('function')

  it 'should have an "setEnv" method', ->
    expect(injector.setEnv).to.be.a('function')

  it 'should have an "getEnv" method', ->
    expect(injector.getEnv).to.be.a('function')

  it 'should return the module when calling the bypassInjection method', ->
    expect(injector.bypassInjection(true)).to.equal(injector)

  it 'should return the module when calling the "setEnv" method', ->
    expect(injector.setEnv('testing')).to.equal(injector)

  it 'should throw an error when setEnv is called with an invalid environment string', ->
    fn = ->
      injector.setEnv('lorem')
    expect(fn).to.throw(Error)

  it 'should return the previously defined environment when calling "getEnv"', ->
    expect(injector.setEnv('testing')).to.equal(injector)
    expect(injector.getEnv()).to.equal('testing')

  describe 'When bypassInjection is set to true (default)', ->
    beforeEach ->
      injector.bypassInjection(true)

    it 'should let you export a module as a regular node.js module', ->
      mathModule = require(mockPath)
      expect(mathModule).to.be.an('object')
      expect(mathModule.square(5)).to.equal(25)
      # TearDown
      delete require.cache[mockPath]

    it 'should let you use @import inside the injector fn to require regular modules', ->
      mathModule = require(mockWithImportPath)
      expect(mathModule.pi).to.equal(Math.PI)
      # TearDown
      delete require.cache[mockWithImportPath]

    it 'should let you use @import inside the injector fn to require npm modules', ->
      mathModule = require(mockWithNpmImportPath)
      expect(mathModule.pi).to.equal(Math.PI)
      # TearDown
      delete require.cache[mockWithNpmImportPath]

    it 'should let you use @import.global inside the injector fn to require a global', ->
      mathModule = require(mockWithGlobalDep)
      expect(mathModule.pi).to.equal(global.PI)
      # TearDown
      delete require.cache[mockWithGlobalDep]

  describe 'When bypassInjection is set to false', ->
    beforeEach ->
      injector.bypassInjection(false)

    it 'should let you export a fn wrapper that accepts an object with dependencies and returns the module when called', ->
      mathModuleWrapper = require(mockPath)
      expect(mathModuleWrapper).to.be.an('function')

      mathModule = mathModuleWrapper()
      expect(mathModule).to.be.an('object')
      # TearDown
      delete require.cache[mockPath]


    it 'should let you export a fn wrapper that accepts an object with dependencies and uses @import internally', ->
      mathModuleWrapper = require(mockWithImportPath)
      expect(mathModuleWrapper).to.be.an('function')
      mathModule = mathModuleWrapper()
      expect(mathModule).to.be.an('object')
      expect(mathModule.pi).to.equal(Math.PI)
      # TearDown
      delete require.cache[mockWithImportPath]

    it 'should let you export a fn wrapper that accepts an object with dependencies(wrapped with an injector fn) and uses @import internally', ->
      mathModuleWrapper = require(mockWithInjectorImportPath)
      expect(mathModuleWrapper).to.be.an('function')
      mathModule = mathModuleWrapper()
      expect(mathModule).to.be.an('object')
      expect(mathModule.pi).to.equal(Math.PI)
      # TearDown
      delete require.cache[mockWithImportPath]

    it 'should let you inject dependencies that are required internally via @import', ->
      mathModuleWrapper = require(mockWithImportPath)
      mathModule = mathModuleWrapper({'PiModule': 'Mocked PI Value'})
      expect(mathModule).to.be.an('object')
      expect(mathModule.pi).to.equal('Mocked PI Value')
      # TearDown
      delete require.cache[mockWithImportPath]

    it 'should let you inject dependencies that are required as globals internally via @import.global', ->
      mathModuleWrapper = require(mockWithGlobalDep)
      mathModule = mathModuleWrapper({'PI': 'Mocked PI Value'})
      expect(mathModule.pi).to.equal('Mocked PI Value')
      # TearDown
      delete require.cache[mockWithGlobalDep]

    describe 'import method', ->
      it 'should let you import a module, and bypass the injector wrapper if there is one', ->
        pi = injector.import('test/mocks/injectorPiModule')
        expect(pi).to.equal(Math.PI)