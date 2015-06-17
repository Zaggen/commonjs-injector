injector (@dependencies)->
  pi = @import(__dirname, './PiModule')
  math =
    square: (x)->  x * x
    pi: pi
    status: injector.getStatus()

  return math

module.exports = injector.getModule()