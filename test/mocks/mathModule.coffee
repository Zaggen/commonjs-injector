injector (@dependencies)->
  math =
    square: (x)->  x * x


module.exports = injector.getModule()