expect = require('chai').expect
global.injector = require('../index')

describe 'commonjs-injector Module', ->
 describe 'When bypassInjection is set to true (default)', ->
   it 'should let you export a module as a regular node.js module', ->
     mathModule = require('./mocks/mathModule')
     expect(mathModule).to.be.an('object')
     expect(mathModule.square(5)).to.equal(25)

   it 'should let you use @import inside the injector fn to require modules', ->
     mathModule = require('./mocks/mathModuleWithImport')
     expect(mathModule).to.be.an('object')
     expect(mathModule.pi).to.equal(Math.PI)

 describe 'When bypassInjection is set to false', ->
   injector.bypassInjection(false)
   it 'should let you export a fn wrapper that accepts an object with dependencies'
