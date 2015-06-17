injector (@dependencies)->
  pi = @import(__dirname, './PiModule')
  math = {
    square: (x)->  x * x
    pi: pi
  }

module.exports = injector.getModule()