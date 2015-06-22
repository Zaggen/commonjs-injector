expect = require('chai').expect
global.injector = require('../index')
mockPath = require.resolve('./mocks/mathModule')
mockWithImportPath = require.resolve('./mocks/mathModuleWithImport')
mockWithNpmImportPath = require.resolve('./mocks/mathModuleWithNpmImport')
global.PI = Math.PI
mockWithGlobalDep = require.resolve('./mocks/mockWithGlobalDep')

describe 'commonjs-injector Module', ->
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