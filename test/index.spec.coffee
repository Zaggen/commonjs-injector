expect = require('chai').expect
global.injector = require('../index')
mockPath = require.resolve('./mocks/mathModule')
mockWithImportPath = require.resolve('./mocks/mathModuleWithImport')

describe 'commonjs-injector Module', ->
 describe 'When bypassInjection is set to true (default)', ->
   beforeEach ->
     injector.bypassInjection(true)

   it 'should let you export a module as a regular node.js module', ->
     mathModule = require(mockPath)
     expect(mathModule).to.be.an('object')
     expect(mathModule.square(5)).to.equal(25)
     delete require.cache[mockPath]

   it 'should let you use @import inside the injector fn to require modules', ->
     mathModule = require(mockWithImportPath)
     expect(mathModule).to.be.an('object')
     expect(mathModule.pi).to.equal(Math.PI)
     delete require.cache[mockWithImportPath]

 describe 'When bypassInjection is set to false', ->
   beforeEach ->
     injector.bypassInjection(false)

   afterEach ->
     delete require.cache[mockPath]

   it 'should let you export a fn wrapper that accepts an object with dependencies', ->
     mathModule = require('./mocks/mathModule')
     expect(mathModule).to.be.an('function')
