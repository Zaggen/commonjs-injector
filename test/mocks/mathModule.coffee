injector (@dependencies)->
  math =
    square: (x)->  x * x
    status: injector.getStatus()

module.exports = injector.getModule()